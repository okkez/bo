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
    @basic.body = Base64.encode64('1000 lunch')
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
      @basic.body = Base64.encode64(<<EOD)
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
end

