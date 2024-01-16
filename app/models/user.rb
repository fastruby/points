class User < ApplicationRecord
  include OmbuLabsAuthenticable

  has_many :estimates
  has_many :comments

  # Returns the email if the user doesn't have a name in Github
  def name
    read_attribute(:name) || email
  end
end
