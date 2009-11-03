# -*- coding: utf-8 -*-
require 'spec_helper'

describe Item do
  before(:each) do
    @valid_attributes = {
      :founds_in   => 1000,
      :founds_out  => nil,
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
    it "is valid" do
      @klass.new.should be_valid
    end
  end

  describe "founds_in is empty" do
    before do
      @basic.founds_in = nil
    end
    it "is valid" do
      @basic.should be_valid
    end
  end

  describe "founds_in is zero" do
    before do
      @basic.founds_in = 0
    end
    it "is not valid" do
      @basic.should_not be_valid
    end
  end

  describe "founds_in is negative value" do
    before do
      @basic.founds_in = -1
    end
    it "is not valid" do
      @basic.should_not be_valid
    end
  end

  describe "founds_in is not integer" do
    before do
      @basic.founds_in = 1.5
    end
    it "is not valid" do
      @basic.should_not be_valid
    end
  end

  describe "acts_as_taggable_on" do
    before do
      Factory.factories.select{|label, f|
        f.build_class == Event
      }.each{|f|
        Factory(f.first)
      }
    end
    it "have 9 records" do
      Item.tagged_with("食費", :on => :tags).should have(9).records
    end
    it "total founds_in is 5310" do
      Item.tagged_with("食費", :on => :tags).sum('founds_in').should == 5310
    end
    it "total founds_in is 1770 in this month" do
      Item.tagged_with("食費", :on => :tags).by_month(Date.today).sum('founds_in').should == 1770
    end
  end

  describe "by_year" do
    before do
      Factory.factories.select{|label, f|
        f.build_class == Event
      }.each{|f|
        Factory(f.first)
      }
    end
    it "total founds_in is 3540 (by_year)" do
      Item.tagged_with("食費", :on => :tags).by_year(Date.today).sum('founds_in').should == 3540
    end
    it "total founds_in is 5310 (all)" do
      Item.tagged_with("食費", :on => :tags).sum('founds_in').should == 5310
    end
  end

  describe "recent_n_months" do
    before do
      Factory.factories.select{|label, f|
        f.build_class == Event
      }.each{|f|
        Factory(f.first)
      }
    end
    it "total founds_in is 1770 (recent 0 month)" do
      Item.tagged_with("食費", :on => :tags).recent_n_months(0).sum('founds_in').should == 1770
    end
    it "total founds_in is 2720 (recent 1 month)" do
      Item.tagged_with("食費", :on => :tags).recent_n_months(1).sum('founds_in').should == 2720
    end
    it "total founds_in is 3240 (recent 2 month)" do
      Item.tagged_with("食費", :on => :tags).recent_n_months(2).sum('founds_in').should == 3240
    end
    it "total founds_in is 3540 (recent 3 month)" do
      Item.tagged_with("食費", :on => :tags).recent_n_months(3).sum('founds_in').should == 3540
    end
    it "total founds_in is 5310 (all)" do
      Item.tagged_with("食費", :on => :tags).sum('founds_in').should == 5310
    end
  end

end
