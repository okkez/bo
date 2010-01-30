class EventsController < ApplicationController

  before_filter :authentication_required, :except => [:index]
  before_filter :prepare, :only => [:show, :edit]

  # GET events_path
  def index
    user = current_user
    if user
      @events = user.events(:order => 'spent_on ASC')
    else
      @events = []
    end
  end

  # GET event_path(:id)
  def show
  end

  # GET edit_event_path(:id)
  def edit
  end

  # DELETE event_path(:id)
  def destroy
    Event.destroy(:conditions => { :id => params[:id], :user_id => current_user.id })
  end

  private

  def prepare
    @event = current_user.events.first(:conditions => { :id => params[:id] })
  end

end
