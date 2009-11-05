require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :name  => 'name',
      :email => 'name@example.com',
    }
    @klass = User
    @basic = @klass.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end

  describe "email is blank" do
    before do
      @basic.email = ''
    end
    it "is valid" do
      @basic.should be_valid
    end
  end

  describe "email is nil" do
    before do
      @basic.email = nil
    end
    it "is valid" do
      @basic.should be_valid
    end
  end

  describe "email is bad format" do
    before do
      @basic.email = 'a..b@example.com'
    end
    it "is not valid" do
      @basic.should_not be_valid
    end
  end

  describe "association" do
    before do
      @user = Factory(:test)
    end
    it "have 3 events" do
      @user.events.should have(3).events
    end
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
