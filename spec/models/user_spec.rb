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

end
