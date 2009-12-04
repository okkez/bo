require 'spec_helper'

describe ItemsController do

  #Delete these examples and add some real ones
  it "should use ItemsController" do
    controller.should be_an_instance_of(ItemsController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_redirect
    end
  end

  describe "GET 'list'" do
    it "should be successful" do
      get 'list'
      response.should be_success
    end
  end
end
