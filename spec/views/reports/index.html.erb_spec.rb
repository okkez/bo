require 'spec_helper'

describe "/reports/index" do
  before(:each) do
    assigns[:date] = Date.new(2010, 6, 6)
    assigns[:prev] = assigns[:date].last_month
    assigns[:next] = assigns[:date].next_month
    assigns[:keywords] = []
    render 'reports/index'
  end

  it{ response.should have_tag('form') }
end
