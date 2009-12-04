require 'spec_helper'

describe "/items/list" do
  before(:each) do
    assigns[:items] = []
    render 'items/list'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('table')
  end
end
