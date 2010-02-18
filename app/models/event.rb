# == Schema Information
# Schema version: 20091204080113
#
# Table name: events
#
#  id           :integer       not null, primary key
#  user_id      :integer       index_events_on_user_id
#  spent_on     :date          not null
#  title        :string(255)
#  note         :text
#  created_at   :datetime
#  updated_at   :datetime
#  lock_version :integer       default(0), not null
#

class Event < ActiveRecord::Base
  default_scope :order => 'spent_on'

  validates_presence_of :user_id
  validates_presence_of :spent_on

  belongs_to :user
  has_many :items, :dependent => :destroy
  accepts_nested_attributes_for :items, :allow_destroy => true,
  :reject_if => lambda{|attr| attr['tag_list'].blank? }

  named_scope :by_month, lambda{|date|
    first = date.beginning_of_month
    last  = date.end_of_month
    { :conditions => ["? <= spent_on and spent_on <= ?", first, last] }
  }

  named_scope :by_year, lambda{|date|
    first = date.beginning_of_year
    last  = date.end_of_year
    { :conditions => ["? <= spent_on and spent_on <= ?", first, last] }
  }

  named_scope :recent_n_months, lambda{|n|
    first = (Date.today << n).beginning_of_month
    last  = Date.today.end_of_month
    { :conditions => ["? <= spent_on and spent_on <= ?", first, last] }
  }

  named_scope :by_range, lambda{|first, last|
    { :conditions => ["? <= spent_on and spent_on <= ?", first, last] }
  }
end
