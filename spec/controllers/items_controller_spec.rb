require 'spec_helper'

describe ItemsController do

  #Delete these examples and add some real ones
  it "should use ItemsController" do
    controller.should be_an_instance_of(ItemsController)
  end


  describe "GET 'index'" do
    before{ get 'index' }
    it{ response.should be_success }
  end

end
