class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.from_omniauth(auth)
    user_attributes = {
      email: auth.info.email,
      name: auth.info.name,
      password: Devise.friendly_token[0,20]
    }
    where(provider: auth.provider, uid: auth.uid).first_or_create.update(user_attributes)
   end
end
