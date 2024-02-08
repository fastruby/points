class User < ApplicationRecord
  include OmbuLabsAuthenticable

  has_many :estimates
  has_many :comments

end
