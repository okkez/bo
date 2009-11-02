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

end
