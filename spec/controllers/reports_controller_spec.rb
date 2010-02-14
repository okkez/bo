require 'spec_helper'

describe ReportsController do

  #Delete these examples and add some real ones
  it "should use ReportsController" do
    controller.should be_an_instance_of(ReportsController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'search'" do
    it "should be successful" do
      get 'search'
      response.should be_success
    end
  end
end
