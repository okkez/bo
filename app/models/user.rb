class User < ActiveRecord::Base

  validates_email_format_of :email, :allow_blank => true

  has_many :events, :dependent => :destroy
end
