# == Schema Information
# Schema version: 20091204080113
#
# Table name: users
#
#  id         :integer       not null, primary key
#  nickname   :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  multi_auth

  validates_email_format_of :email, :allow_blank => true

  has_many :events, :dependent => :destroy
end
