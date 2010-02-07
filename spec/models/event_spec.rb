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
      @items.all?(&:valid?).should be_true
    end
  end

  describe "spent_on is nil" do
    subject{ @basic.spent_on = nil; @basic }
    it{ should_not be_valid }
  end

  describe "named_scope" do
    describe "by_month" do
      before do
        Factory(:event, :spent_on => Date.today.beginning_of_month - 1)
        Factory(:event, :spent_on => Date.today.beginning_of_month)
        Factory(:event, :spent_on => Date.today)
        Factory(:event, :spent_on => Date.today)
        Factory(:event, :spent_on => Date.today.end_of_month)
        Factory(:event, :spent_on => Date.today.end_of_month + 1)
      end
      it{ Event.by_month(Date.today).should have(4).events }
    end
    describe "by_year" do
      before do
        Factory(:event, :spent_on => Date.today.beginning_of_year - 1)
        Factory(:event, :spent_on => Date.today.beginning_of_year)
        Factory(:event, :spent_on => Date.today)
        Factory(:event, :spent_on => Date.today)
        Factory(:event, :spent_on => Date.today.end_of_year)
        Factory(:event, :spent_on => Date.today.end_of_year + 1)
      end
      it{ Event.by_year(Date.today).should have(4).events }
    end
    describe "recent_n_months" do
      before do
        Factory(:event, :spent_on => 3.months.ago.beginning_of_month - 1)
        Factory(:event, :spent_on => 3.months.ago.beginning_of_month)
        Factory(:event, :spent_on => 3.months.ago)
        Factory(:event, :spent_on => Date.today)
        Factory(:event, :spent_on => Date.today + 1)
      end
      it{ Event.recent_n_months(3).should have(3).events }
    end
  end
end
