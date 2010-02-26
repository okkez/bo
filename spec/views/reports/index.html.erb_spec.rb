require 'spec_helper'

describe "/reports/index" do
  before(:each) do
    render 'reports/index'
  end

  it{ response.should have_tag('form') }
end
