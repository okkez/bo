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

  describe "basic" do
    it{ @basic.should be_valid }
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

  describe "spent_on is nil" do
    subject{ @basic.spent_on = nil; @basic }
    it{ should_not be_valid }
  end
end
