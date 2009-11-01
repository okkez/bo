class Item < ActiveRecord::Base
  validates_presence_of :amount
  validates_numericality_of :amount, :grater_than => 0, :only_integer => true
end
