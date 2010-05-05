# -*- coding: utf-8 -*-
require 'spec_helper'

describe MailRegister do
  before do
    @user = Factory(:user)
    token = @user.tokens.first(:conditions => { :purpose => "mail" }).token
    @basic = TMail::Mail.new
    @basic.to = "bo+#{token}@okkez.net"
    @basic.from = 'Test <admin@example.com>'
    @basic.subject = 'test mail'
    @basic.date = Time.now
    @basic.mime_version = '1.0'
    @basic.set_content_type 'text', 'plain', {'charset'=>'iso-2022-jp'}
    @basic.body = '1000 lunch'
  end

  describe 'basic' do
    it do
      lambda{ MailRegister.entry(@basic) }.should_not raise_error
    end
    it do
      lambda{ MailRegister.entry(@basic) }.should change(Event, :count).by(1)
    end
    it do
      lambda{ MailRegister.entry(@basic) }.should change(Item, :count).by(2)
    end
  end

  describe "no such user" do
    before{ @basic.to = "bo+#{'2'*20}@okkez.net" }
    it do
      lambda{ MailRegister.entry(@basic) }.should_not raise_error
    end
    it do
      lambda{ MailRegister.entry(@basic) }.should_not change(Event, :count)
    end
    it do
      lambda{ MailRegister.entry(@basic) }.should_not change(Item, :count)
    end
  end

  describe "multi lines" do
    before do
      @basic.body = <<EOD
500 lunch1
1000 lunch2
1200 lunch3
1300 lunch4
EOD
    end
    it do
      lambda{ MailRegister.entry(@basic) }.should_not raise_error
    end
    it do
      lambda{ MailRegister.entry(@basic) }.should change(Event, :count).by(1)
    end
    it do
      lambda{ MailRegister.entry(@basic) }.should change(Item, :count).by(5)
    end
  end

  describe "japanese" do
    before do
      @basic.body = NKF.nkf('-Wj', "100 食費\n")
    end
    it do
      lambda{ MailRegister.entry(@basic) }.should_not raise_error
    end
    it do
      lambda{ MailRegister.entry(@basic) }.should change(Event, :count).by(1)
    end
    it do
      lambda{ MailRegister.entry(@basic) }.should change(Item, :count).by(2)
    end
  end

  describe "real mail" do
    before do
      @target = TMail::Mail.parse(NKF.nkf('-m0 -Wj', <<STR))
Delivered-To: bo+3553b966608516b4daad@okkez.net
Received: by 10.142.144.10 with SMTP id r10cs212734wfd;
        Tue, 4 May 2010 22:54:12 -0700 (PDT)
Received: by 10.114.253.4 with SMTP id a4mr1056238wai.132.1273038851900;
        Tue, 04 May 2010 22:54:11 -0700 (PDT)
Return-Path: <quick_hack@ezweb.ne.jp>
Received: from ezweb.ne.jp (nx3oBP01-10.ezweb.ne.jp [59.135.39.214])
        by mx.google.com with ESMTP id 19si15797587wag.36.2010.05.04.22.54.09;
        Tue, 04 May 2010 22:54:11 -0700 (PDT)
Received-SPF: pass (google.com: domain of quick_hack@ezweb.ne.jp designates 59.135.39.214 as permitted sender) client-ip=59.135.39.214;
Authentication-Results: mx.google.com; spf=pass (google.com: domain of quick_hack@ezweb.ne.jp designates 59.135.39.214 as permitted sender) smtp.mail=quick_hack@ezweb.ne.jp
Received: from nxev13mp01 (localhost [127.0.0.1])
	by nxev13mp01.ezweb.ne.jp (EZweb Mail) with SMTP id AA195CB0FC0BD
	for <bo+3553b966608516b4daad@okkez.net>; Wed,  5 May 2010 14:54:08 +0900 (JST)
From: quick_hack@ezweb.ne.jp
To: bo+3553b966608516b4daad@okkez.net
Subject: =?iso-2022-jp?B?GyRCJCYkSSRzJE47TTlxGyhC?=
Message-ID: <2010050514540868892800003667@nxev13mp01.ezweb.ne.jp>
Date: Wed, 5 May 2010 14:54:08 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit

250 食費 昼食 ざるうどん
STR
      token = @user.tokens.first(:conditions => { :purpose => "mail" }).token
      @target.to = "bo+#{token}@okkez.net"
    end
    it do
      lambda{ MailRegister.entry(@target) }.should_not raise_error
    end
    it do
      lambda{ MailRegister.entry(@target) }.should change(Event, :count).by(1)
    end
    it do
      lambda{ MailRegister.entry(@target) }.should change(Item, :count).by(2)
    end
  end
end

