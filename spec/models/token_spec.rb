require 'spec_helper'

describe Token do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :token => "1"*20,
      :purpose => "mail"
    }
    @klass = Token
    @basic = @klass.new(@valid_attributes)
  end

  describe "basic" do
    it{ @basic.should be_valid }
  end

  describe "validation" do
    describe "token is nil" do
      subject{ @basic.token = nil; @basic }
      it{ should_not be_valid }
    end
    describe "token is empty" do
      subject{ @basic.token = ''; @basic }
      it{ should_not be_valid }
    end
    describe "token is invalid format" do
      subject{ @basic.token = "1"; @basic }
      it{ should_not be_valid }
    end
    describe "token is not unique" do
      subject{ Factory(:token, :user_id => 1); @basic }
      it{ should_not be_valid }
    end
  end

  describe "generate" do
    before do
      @token = Token.new(:user_id => 1, :token => Token.generate, :purpose => 'API')
    end
    it{ @token.should be_valid }
  end
end
