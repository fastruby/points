OmbuLabs::Auth::Engine.routes.draw do
  devise_for :users, class_name: OmbuLabs::Auth::User, module: :devise, controllers: { omniauth_callbacks: 'ombu_labs/auth/callbacks' }
end
