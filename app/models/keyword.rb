class Keyword < ActiveRecord::Base

  validates_presence_of :name

  acts_as_tree

end
