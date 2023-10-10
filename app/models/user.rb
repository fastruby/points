class User < ApplicationRecord
  include OmbuLabsAuthenticable

  has_many :estimates
end
