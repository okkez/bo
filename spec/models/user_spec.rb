require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :nickname  => 'nickname',
      :email     => 'nickname@example.com',
    }
    @klass = User
    @basic = @klass.new(@valid_attributes)
  end

  describe "basic" do
    it{ @basic.should be_valid }
  end

  describe "validations" do
    describe "email is blank" do
      subject{ @basic.email = ''; @basic }
      it{ should be_valid }
    end

    describe "email is nil" do
      subject{ @basic.email = nil; @basic }
      it{ should be_valid }
    end

    describe "email is bad format" do
      subject{ @basic.email = 'a..b@example.com'; @basic }
      it{ should_not be_valid }
    end
  end

  describe "association" do
    before{ @user = Factory(:test) }
    it{ @user.events.should have(3).events }
    describe "destroy user" do
      before do
        @user.destroy
      end
      it "also destroy events" do
        Event.all.should have(0).events
      end
    end
  end

  describe "callback" do
    describe "after_create" do
      before do
        @user = User.create(@basic.attributes)
      end
      it{ @user.tokens.should have(2).tokens }
    end
    describe "after_create" do
      before do
        @user = User.new(@basic.attributes)
        @user.save
      end
      it{ @user.tokens.should have(2).tokens }
    end
  end

  describe "token" do
    before do
      @user = Factory(:test)
    end
    it{ @user.token("mail").should be_instance_of(Token) }
    it{ @user.token("API").should be_instance_of(Token) }
  end

  describe "to_address" do
    before do
      @user = Factory(:test)
    end
    it{ @user.to_address.should match(/bo\+[0-9a-f]{20}@okkez\.net/)}
  end

  describe "refresh_token" do
    before do
      @user = Factory(:test)
    end
    ['mail', 'API'].each do |purpose|
      it{
        lambda{
          @user.refresh_token(purpose)
        }.should change{ @user.tokens.detect{|v| v.purpose == purpose }.token }
      }
      it{
        lambda{
          @user.refresh_token(purpose)
        }.should_not change{ @user.tokens.detect{|v| v.purpose != purpose }.token }
      }
    end
  end
end
