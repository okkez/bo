class EventsController < ApplicationController

  before_filter :authentication_required, :except => [:index]
  before_filter :prepare, :only => [:show, :edit, :update]

  # GET events_path
  def index
    user = current_user
    if user
      @events = user.events(:order => 'spent_on ASC').
        paginate(:page => params[:page], :per_page => 10)
    else
      @events = [].paginate(:page => params[:page])
    end
  end

  # GET new_event_path
  def new
    @event = Event.new(:spent_on => Date.today)
    @event.items.build
  end

  # POST events_path
  def create
    @event = Event.new(params[:event])
    @event.user = current_user
    if @event.save
      flash[:notice] = "Event was successfully created."
      redirect_to events_path
    else
      render :action => 'new'
    end
  end

  # GET event_path(:id)
  def show
  end

  # GET edit_event_path(:id)
  def edit
  end

  # PUT event_path(:id)
  def update
    @event.attributes = params[:event]
    if @event.save
      flash[:notice] = "Event was successfully updated."
      redirect_to events_path
    else
      render :action => 'edit'
    end
  end

  # DELETE event_path(:id)
  def destroy
    @event = Event.first(:conditions => { :id => params[:id], :user_id => current_user.id })
    if @event
      @event.destroy
      flash[:notice] = "Event was successfully destroyed."
    end
    redirect_to events_path
  end

  private

  def prepare
    @event = current_user.events.first(:include => :items, :conditions => { :id => params[:id] })
  end

end
