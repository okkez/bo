# == Schema Information
# Schema version: 20100209145338
#
# Table name: tokens
#
#  id         :integer       not null, primary key
#  user_id    :integer
#  token      :string(255)
#  purpose    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Token < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id

  validates_presence_of   :token
  validates_format_of     :token, :with => /\A[a-z0-9]{20}\z/, :allow_blank => true
  validates_uniqueness_of :token

  def self.generate
    begin
      new_token = SecureRandom.hex(20)
    end while Token.exists?(:token => new_token)
    new_token
  end
end
