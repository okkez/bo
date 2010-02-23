require 'spec_helper'

describe EventsController do

  before do
    @user = Factory(:test)
  end

  describe "GET 'index'" do
    describe "by anonymous user" do
      before{ get 'index' }
      it{ response.should be_success }
      it{ response.should render_template("index") }
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

  describe "GET new" do
    describe "by anonymous user" do
      before{ get 'new' }
      it{ response.should be_redirect }
    end
    describe "by user" do
      before do
        login_as(@user)
        get 'new'
      end
      it{ response.should be_success }
      it{ response.should render_template("new") }
    end
  end

  describe "GET show" do
    describe "by anonymous user" do
      before{ get 'show' }
      it{ response.should be_redirect }
    end
    describe "by user" do
      before do
        login_as(@user)
        get 'show'
      end
      it{ response.should be_success }
      it{ response.should render_template("show") }
    end
  end

  describe "GET edit" do
    describe "by anonymous user" do
      before{ get 'edit' }
      it{ response.should be_redirect }
    end
    describe "by user" do
      before do
        login_as(@user)
        get 'edit'
      end
      it{ response.should be_success }
      it{ response.should render_template("edit") }
    end
  end

  describe "POST create" do
    describe "by anonymous user" do
      before{ post 'create' }
      it{ response.should be_redirect }
    end
    describe "by user" do
      before do
        login_as(@user)
        event = Factory.build(:morning)
        post 'create', :event => event.attributes
      end
      it{ response.should be_redirect }
      it{ response.should redirect_to(events_path) }
    end
  end

  describe "PUT update" do
    describe "by anonymous user" do
      before{ put 'update' }
      it{ response.should be_redirect }
    end
  end

  describe "DELETE destroy" do
    describe "by anonymous user" do
      before{ delete 'destroy' }
      it{ response.should be_redirect }
    end
  end

end
