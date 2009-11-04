# -*- coding: utf-8 -*-
class Item < ActiveRecord::Base
  validates_numericality_of :founds_in, :greater_than => 0, :only_integer => true, :allow_nil => true
  validates_numericality_of :founds_out, :greater_than => 0, :only_integer => true, :allow_nil => true

  belongs_to :event

  acts_as_taggable_on :tags

  default_scope :include => { :event => :user }

  named_scope :by_month, lambda{|date|
    first = date.beginning_of_month
    last  = date.end_of_month
    { :conditions => ["? <= events.spent_on and events.spent_on <= ?", first, last] }
  }

  named_scope :by_year, lambda{|date|
    first = date.beginning_of_year
    last  = date.end_of_year
    { :conditions => ["? <= events.spent_on and events.spent_on <= ?", first, last] }
  }

  named_scope :recent_n_months, lambda{|n|
    first = (Date.today << n).beginning_of_month
    last  = Date.today.end_of_month
    { :conditions => ["? <= events.spent_on and events.spent_on <= ?", first, last] }
  }
end
