class Token < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id

  validates_presence_of   :token
  validates_format_of     :token, :with => /\A[a-z0-9]{20}\z/, :allow_blank => true
  validates_uniqueness_of :token
end
