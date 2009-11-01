require 'spec_helper'

describe Item do
  before(:each) do
    @valid_attributes = {
      :title  => 'title',
      :note   => 'note',
      :amount => 1000,
    }
  end

  it "should create a new instance given valid attributes" do
    Item.create!(@valid_attributes)
  end
end
