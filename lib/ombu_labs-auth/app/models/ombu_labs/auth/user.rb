module OmbuLabs::Auth
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable,
           :validatable, :omniauthable
  end
end
