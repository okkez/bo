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

  describe "GET 'templates'" do
    describe "by anonymous user" do
      before{ get 'templates' }
      it{ response.should be_redirect }
    end
    describe "by user" do
      before do
        login_as(@user)
        get 'templates'
      end
      it{ response.should be_success }
      it{ response.should render_template("/events/index") }
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
    describe "with template" do
      before do
        login_as(@user)
        @event = Factory(:event, :user=> @user, :items => [Factory(:item)])
        @expected = @event.attributes
        @expected.delete("id")
        get 'new', :template_id => @event.id
      end
      it{ response.should be_success }
      it{ response.should render_template("new") }
      it{ assigns[:event].attributes.should == @expected }
      it{ assigns[:event].items.should have(1).item }
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
        @event = Factory(:morning)
        Event.should_receive(:new).and_return(@event)
        @event.should_receive(:save).and_return(true)
        post 'create', :event => @event.attributes
      end
      it{ response.should be_redirect }
      it{ response.should redirect_to(event_path(@event)) }
    end
  end

  describe "PUT update" do
    describe "by anonymous user" do
      before{ put 'update' }
      it{ response.should be_redirect }
    end
    describe "by user" do
      before do
        login_as(@user)
        @event = Factory(:morning, :user => @user)
        put 'update', :id => @event.id, :event => @event.attributes
      end
      it{ response.should be_redirect }
      it{ response.should redirect_to(event_path(@event)) }
    end
  end

  describe "DELETE destroy" do
    describe "by anonymous user" do
      before{ delete 'destroy' }
      it{ response.should be_redirect }
    end
    describe "by user" do
      before do
        login_as(@user)
        event = mock('event')
        event.should_receive(:destroy)
        Event.should_receive(:first).and_return(event)
        delete 'destroy', :id => 1
      end
      it{ response.should be_redirect }
      it{ response.should redirect_to(events_path) }
      it{ response.flash[:notice].should_not be_blank }
    end
  end

  describe "API" do
    describe "GET show" do
      describe "no such user" do
        before do
          get 'show', :format => 'json', :id => 1, :token => 'x'*20
        end
        it{ response.status.should == "403 Forbidden" }
      end
      describe "user exist" do
        describe "without callback" do
          before do
            user = Factory(:user)
            @event = user.events.create(Factory.build(:morning).attributes)
            get('show', :format => 'json', :id => @event.id,
                :token => user.tokens.first(:conditions => { :purpose => 'API' }).token)
          end
          it{ response.should be_success }
          it{ ActiveSupport::JSON.decode(response.body).should be_instance_of(Hash) }
        end
        describe "with callback" do
          before do
            user = Factory(:user)
            @event = user.events.create(Factory.build(:morning).attributes)
            get('show', :format => 'json', :id => @event.id, :callback => "show",
                :token => user.tokens.first(:conditions => { :purpose => 'API' }).token)
          end
          it{ response.should be_success }
          it{ response.body.should match(%r!show\(.+\)!) }
        end
      end
    end
    describe "POST create" do
      describe "no such user" do
        before do
          event = Factory.build(:morning)
          post 'create', :format => 'json', :token => 'x'*20, :event => event.attributes
        end
        it{ response.status.should == "403 Forbidden" }
      end
      describe "user exist using JSON" do
        before do
          user = Factory(:user)
          event = Factory.build(:morning)
          items = event.items
          request = {}
          request[:event] = event.attributes
          request[:event][:items_attributes] = items.map(&:attributes)
          hash = {
            :format  => 'json',
            :token   => user.tokens.first(:conditions => { :purpose => "API" }).token,
            :request => request.to_json
          }
          post 'create', hash
        end
        it{ response.should be_success }
      end
      describe "user exist using plain data" do
        before do
          user = Factory(:user)
          event = Factory.build(:morning)
          items = event.items
          request = {}
          request[:event] = event.attributes
          request[:event][:items_attributes] = items.map(&:attributes)
          hash = {
            :format  => 'json',
            :token   => user.tokens.first(:conditions => { :purpose => "API" }).token,
          }.merge(request)
          post 'create', hash
        end
        it{ response.should be_success }
      end
    end
    describe "PUT update" do
      describe "no such user" do
        before do
          event = Factory.build(:morning)
          put 'update', :format => 'json', :token => 'x'*20, :event => event.attributes
        end
        it{ response.status.should == "403 Forbidden" }
      end
      describe "user exist using json" do
        before do
          user = Factory(:user)
          event = Factory(:morning, :user => user)
          items = event.items
          request = {}
          request[:event] = event.attributes
          request[:event][:items_attributes] = items.map(&:attributes)
          hash = {
            :format => 'json', :id => event.id,
            :token => user.tokens.first(:conditions => { :purpose => "API" }).token,
            :request => request.to_json
          }
          put 'update', hash
        end
        it{ response.should be_success }
      end
      describe "user exist using plain" do
        before do
          user = Factory(:user)
          event = Factory(:morning, :user => user)
          items = event.items
          request = {}
          request[:event] = event.attributes
          request[:event][:items_attributes] = items.map(&:attributes)
          hash = {
            :format => 'json', :id => event.id,
            :token => user.tokens.first(:conditions => { :purpose => "API" }).token,
          }.merge(request)
          put 'update', hash
        end
        it{ response.should be_success }
      end
    end
    describe "DELETE destroy" do
      describe "no such user" do
        before do
          delete 'destroy', :format => 'json', :id => 1, :token => 'x'*20
        end
        it{ response.status.should == "403 Forbidden" }
      end
      describe "user exist" do
        describe "without callback" do
          before do
            user = Factory(:user)
            @event = user.events.create(Factory.build(:morning).attributes)
            delete('destroy', :format => 'json', :id => @event.id,
                   :token => user.tokens.first(:conditions => { :purpose => "API" }).token)
          end
          it{ response.should be_success }
          it{ Event.exists?(@event.id).should_not be_true }
        end
      end
    end
  end

end
