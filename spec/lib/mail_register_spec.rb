require 'spec_helper'


describe MailRegister do
  before do
    @basic = TMail::Mail.new
    @basic.to = "bo+#{'2'*20}@okkez.net"
    @basic.from = 'Test <admin@example.com>'
    @basic.subject = 'test mail'
    @basic.date = Time.now
    @basic.mime_version = '1.0'
    @basic.set_content_type 'text', 'plain', {'charset'=>'iso-2022-jp'}
    @basic.body = Base64.encode64('1000 lunch')
  end

  describe 'basic' do
    before{ Factory(:user_with_token) }
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
end
