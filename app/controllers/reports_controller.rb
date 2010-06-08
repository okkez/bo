# -*- coding: utf-8 -*-
class ReportsController < ApplicationController

  before_filter :authentication_required

  def index
    if params[:year] && params[:month]
      @date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    else
      @date = Date.today
    end
    first = @date.beginning_of_month
    last  = @date.end_of_month
    @prev = first - 1
    @next = last + 1
    load_report(first, last)
  end

  def search
    first = Date.parse(params[:first])
    last  = Date.parse(params[:last])
    load_report(first, last)
  end

  private

  def load_report(first, last)
    @events = current_user.events.by_range(first, last).all(:include => { :items => :taggings })
    @keywords = Keyword.roots.map{|root| root.self_and_descendants }.flatten.map(&:name)
    @report = @events.each_with_object(Hash.new{|h,k| h[k] = Hash.new(0) }){|event, memo|
      event.items.each{|item|
        item.tag_list.each{|tag|
          memo[tag][:founds_in] += item.founds_in || 0
          memo[tag][:founds_out] += item.founds_out || 0
        }
      }
    }
  end

end
