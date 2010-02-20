# == Schema Information
# Schema version: 20100209145338
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
  has_many :tokens

  after_create :create_tokens

  def refresh_token(purpose)
    token = self.tokens.detect{|t| t.purpose == purpose }
    token.update_attributes(:token => Token.generate)
  end

  private

  def create_tokens
    self.tokens.create(:token => Token.generate, :purpose => 'mail')
    self.tokens.create(:token => Token.generate, :purpose => 'API')
  end
end
