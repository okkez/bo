class ItemsController < ApplicationController

  def index
    @items = Item.all(:order => 'events.spent_on, items.event_id, items.founds_in nulls last')
  end

end
