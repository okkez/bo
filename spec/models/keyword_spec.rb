require 'spec_helper'

describe Keyword do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :parent_id => nil
    }
    @klass = Keyword
    @basic = @klass.new(@valid_attributes)
  end

  describe "basic" do
    it{ @basic.should be_valid }
  end

  describe "validation" do
    describe "name" do
      describe "is nil" do
        subject{ @basic.name = nil; @basic }
        it{ should_not be_valid }
      end
      describe "is empty" do
        subject{ @basic.name = ""; @basic }
        it{ should_not be_valid }
      end
    end
  end

  describe "association" do
    describe "acts_as_tree" do
      before do
        @parent = Keyword.create!(:name => 'parent')
        @child  = @parent.children.create!(:name => 'child1')
        @child  = @parent.children.create!(:name => 'child2')
      end
      it{ @parent.children.should have(2).records }
      it{ @child.parent.should == @parent }
    end
  end
end
