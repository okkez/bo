require 'spec_helper'

describe Event do
  before :each do
    @valid_attributes = {
      :user_id  => 0,
      :title    => 'title',
      :spent_on => Date.today,
      :note     => 'note',
    }
    @klass = Event
    @basic = @klass.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes)
  end

  describe "all factories" do
    before do
      @items = []
      Factory.factories.select{|label, f|
        f.build_class == Event
      }.each{|label, f|
        @items << Factory.build(label)
      }
    end
    it "is valid" do
      @items.all?(&:valid?)
    end
  end

  describe "spent_on is empty" do
    before do
      @basic.spent_on = nil
    end
    it "is not valid" do
      @basic.should_not be_valid
    end
  end
end
