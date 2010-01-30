require 'spec_helper'


describe MailRegister do
  before do
    @basic = TMail::Mail.new
    @basic.to = "bo+#{'1'*20}@gmail.com"
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
  end
end
