require 'spec_helper'

describe ReportsController do

  before do
    @user = Factory(:test)
  end

  describe "GET 'index'" do
    describe "by anonymous user" do
      before{ get 'index' }
      it{ response.should be_redirect }
      it{ response.should redirect_to(root_path) }
    end
    describe "by user" do
      before do
        login_as(@user)
        get 'index'
      end
      it{ response.should be_success }
      it{ response.should render_template("index") }
    end
  end

  describe "GET 'search'" do
    describe "by anonymous user" do
      before{ get 'search' }
      it{ response.should be_redirect }
      it{ response.should redirect_to(root_path) }
    end
    describe "by user" do
      before do
        login_as(@user)
        first = Date.today.beginning_of_month
        last  = Date.today.end_of_month
        get 'search', :first => first.to_s, :last => last.to_s
      end
      it{ response.should be_success }
      it{ response.should render_template("search") }
    end
  end
end
