# -*- coding: utf-8 -*-
class Item < ActiveRecord::Base
  validates_presence_of :spent_on
  validates_presence_of :amount
  validates_numericality_of :amount, :greater_than => 0, :only_integer => true

  acts_as_taggable_on :tags

  default_scope :order => 'spent_on'

  # TODO order オプションを付ける
  named_scope :by_month, lambda{|date|
    first = date.beginning_of_month
    last  = date.end_of_month
    { :conditions => ["? <= items.spent_on and items.spent_on <= ?", first, last] }
  }

  named_scope :by_year, lambda{|date|
    first = date.beginning_of_year
    last  = date.end_of_year
    { :conditions => ["? <= items.spent_on and items.spent_on <= ?", first, last] }
  }

  named_scope :recent_n_months, lambda{|n|
    first = (Date.today << n).beginning_of_month
    last  = Date.today.end_of_month
    { :conditions => ["? <= items.spent_on and items.spent_on <= ?", first, last] }
  }
end
