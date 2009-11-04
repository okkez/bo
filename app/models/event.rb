class Event < ActiveRecord::Base
  default_scope :order => 'spent_on'

  validates_presence_of :spent_on

  belongs_to :user
  has_many :items, :dependent => :destroy
end
