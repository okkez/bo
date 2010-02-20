class Keyword < ActiveRecord::Base

  validates_presence_of :name

  acts_as_list :scope => :parent_id
  acts_as_nested_set :order => "position"

end
