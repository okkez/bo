# -*- coding: utf-8 -*-
require 'spec_helper'

describe Item do
  before(:each) do
    @valid_attributes = {
      :title    => 'title',
      :spent_on => Date.today,
      :note     => 'note',
      :amount   => 1000,
    }
    @klass = Item
    @basic = @klass.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    Item.create!(@valid_attributes)
  end

  describe "all factories" do
    before do
      @items = []
      Factory.factories.select{|label, f|
        f.build_class == Item
      }.each{|label, f|
        @items << Factory.build(label)
      }
    end
    it "is valid" do
      @items.all?(&:valid?)
    end
  end

  describe "is empty" do
    it "is not valid" do
      @klass.new.should_not be_valid
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

  describe "amount is empty" do
    before do
      @basic.amount = nil
    end
    it "is not valid" do
      @basic.should_not be_valid
    end
  end

  describe "amount is zero" do
    before do
      @basic.amount = 0
    end
    it "is not valid" do
      @basic.should_not be_valid
    end
  end

  describe "amount is negative value" do
    before do
      @basic.amount = -1
    end
    it "is not valid" do
      @basic.should_not be_valid
    end
  end

  describe "amount is not integer" do
    before do
      @basic.amount = 1.5
    end
    it "is not valid" do
      @basic.should_not be_valid
    end
  end

  describe "acts_as_taggable_on" do
    before do
      Factory.factories.each{|f| Factory(f.first) }
    end
    it "have 3 records" do
      Item.tagged_with("食費", :on => :tags).should have(3).records
    end
    it "total amount is 1770" do
      Item.tagged_with("食費", :on => :tags).sum('amount').should == 1770
    end
    it "total amount is 1770 in this month" do
      Item.tagged_with("食費", :on => :tags).by_month(Date.today).sum('amount').should == 1770
    end
  end

  describe "by_year" do
    before do
      Factory.factories.each{|f| Factory(f.first) }
      Factory(:morning, :spent_on => 1.years.ago)
      Factory(:lunch,   :spent_on => 1.years.ago)
      Factory(:dinner,  :spent_on => 1.years.ago)
    end
    it "total amount is 1770 (by_year)" do
      Item.tagged_with("食費", :on => :tags).by_year(Date.today).sum('amount').should == 1770
    end
    it "total amount is 3540 (all)" do
      Item.tagged_with("食費", :on => :tags).sum('amount').should == 3540
    end
  end

  describe "recent_n_months" do
    before do
      Factory.factories.each{|f| Factory(f.first) }
      Factory(:morning, :spent_on => 3.months.ago)
      Factory(:lunch,   :spent_on => 2.months.ago)
      Factory(:dinner,  :spent_on => 1.months.ago)
    end
    it "total amount is 1770 (recent 0 month)" do
      Item.tagged_with("食費", :on => :tags).recent_n_months(0).sum('amount').should == 1770
    end
    it "total amount is 2720 (recent 1 month)" do
      Item.tagged_with("食費", :on => :tags).recent_n_months(1).sum('amount').should == 2720
    end
    it "total amount is 3240 (recent 2 month)" do
      Item.tagged_with("食費", :on => :tags).recent_n_months(2).sum('amount').should == 3240
    end
    it "total amount is 3540 (recent 3 month)" do
      Item.tagged_with("食費", :on => :tags).recent_n_months(3).sum('amount').should == 3540
    end
    it "total amount is 3540 (all)" do
      Item.tagged_with("食費", :on => :tags).sum('amount').should == 3540
    end
  end

end
