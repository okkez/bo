# == Schema Information
# Schema version: 20100209145338
#
# Table name: keywords
#
#  id        :integer       not null, primary key
#  name      :string(255)   not null
#  parent_id :integer
#  lft       :integer
#  rgt       :integer
#  position  :integer
#

class Keyword < ActiveRecord::Base

  validates_presence_of :name

  acts_as_list :scope => :parent_id
  acts_as_nested_set :order => "position"

end
