class EventsController < ApplicationController

  before_filter :authentication_required, :except => [:index]
  before_filter :prepare_json, :only => [:create, :update]
  before_filter :prepare, :only => [:show, :edit, :update]

  # GET events_path
  def index
    user = current_user
    if user
      @events = user.events(:order => 'spent_on ASC').
        paginate(:page => params[:page], :per_page => 50)
    else
      @events = [].paginate(:page => params[:page])
    end
  end

  # GET new_event_path
  def new
    if params[:template]
      @event = current_user.events.first(:include => :items,
                                         :conditions => { :id => params[:template] })
    else
      @event = Event.new(:spent_on => Date.today)
      @event.items.build
    end
  end

  # POST events_path
  def create
    @event = Event.new(params[:event])
    @event.user = current_user
    respond_to do |format|
      if @event.save
        message = _("Event was successfully created.")
        format.html{
          flash[:notice] = message
          redirect_to event_path(@event)
        }
        format.json{
          hash = {}
          hash[:event] = @event.attributes
          hash[:event][:items] = @event.items.map(&:attributes)
          render :json => hash.merge(:success => true, :message => message)
        }
      else
        format.html{ render :action => 'new' }
        format.json{
          render :json => { :success => false, :message => @event.errors.full_message }
        }
      end
    end
  end

  # GET event_path(:id)
  def show
    respond_to do |format|
      format.html
      format.json{
        hash = {}
        hash[:event] = @event.attributes
        hash[:event][:items] = @event.items.map(&:attributes)
        render :json => hash, :callback => params[:callback]
      }
    end
  end

  # GET edit_event_path(:id)
  def edit
  end

  # PUT event_path(:id)
  def update
    @event.attributes = params[:event]
    respond_to do |format|
      if (success = @event.save)
        message = _("Event was successfully updated.")
        format.html{
          flash[:notice] = message
          redirect_to event_path(@event)
        }
      else
        message = @event.errors.full_message
        format.html{ render :action => 'edit' }
      end
      format.json{
        hash = {}
        hash[:event] = @event.attributes
        hash[:event][:items_attributes] = @event.items.map(&:attributes)
        render :json => hash.merge(:success => success,
                                   :message => message,
                                   :callback => params[:callback])
      }
    end
  end

  # DELETE event_path(:id)
  def destroy
    @event = Event.first(:conditions => { :id => params[:id], :user_id => current_user.id })
    if @event
      @event.destroy
      message = _("Event was successfully destroyed.")
      flash[:notice] = message
    end
    respond_to do |format|
      format.html{ redirect_to events_path }
      format.json{ render :json => { :message => message }, :callback => params[:callback] }
    end
  end

  private

  def prepare_json
    if params[:format] == 'json' && params.member?(:request)
      data = ActiveSupport::JSON.decode(params[:request])
      params[:event] = data["event"]
    end
  end

  def prepare
    @event = current_user.events.first(:include => :items, :conditions => { :id => params[:id] })
  end

end
