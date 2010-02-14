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

  describe "basic" do
    it{ @basic.should be_valid }
  end

  describe "validation" do
    describe "is empty" do
      subject{ @klass.new }
      it{ should be_valid }
    end

    describe "founds_in" do
      describe " is empty" do
        subject{ @basic.founds_in = nil; @basic }
        it{ should be_valid }
      end

      describe " is zero" do
        subject{ @basic.founds_in = 0; @basic }
        it{ should_not be_valid }
      end

      describe " is negative value" do
        subject{ @basic.founds_in = -1; @basic }
        it{ should_not be_valid }
      end

      describe " is not integer" do
        subject{ @basic.founds_in = 1.5; @basic }
        it{ should_not be_valid }
      end
    end

    describe "founds_out" do
      describe " is empty" do
        subject{ @basic.founds_out = nil; @basic }
        it{ should be_valid }
      end

      describe " is zero" do
        subject{ @basic.founds_out = 0; @basic }
        it{ should_not be_valid }
      end

      describe " is negative value" do
        subject{ @basic.founds_out = -1; @basic }
        it{ should_not be_valid }
      end

      describe " is not integer" do
        subject{ @basic.founds_out = 1.5; @basic }
        it{ should_not be_valid }
      end
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
    it do
      Item.tagged_with("食費", :on => :tags).should have(9).records
    end
    describe "total founds_in" do
      it do
        Item.tagged_with("食費", :on => :tags).sum('founds_in').should == 5310
      end
    end
  end

end
