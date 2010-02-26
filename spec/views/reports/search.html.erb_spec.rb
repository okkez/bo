require 'spec_helper'

describe "/reports/search" do
  before(:each) do
    assigns[:keywords] = []
    render 'reports/search'
  end

  it{ response.should have_tag('form') }
end
