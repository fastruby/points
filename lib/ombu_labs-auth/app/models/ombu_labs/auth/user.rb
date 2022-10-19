module OmbuLabs::Auth
  class User < ApplicationRecord
    self.table_name = "users"

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :trackable,
            :validatable, :omniauthable
    
    def self.from_omniauth(auth)
      user_attributes = {
        email: auth.info.email,
        name: auth.info.name,
        password: Devise.friendly_token[0, 20]
      }
      where(provider: auth.provider, uid: auth.uid).first_or_create.tap { |user| user.update(user_attributes) }
    end
  end
end
