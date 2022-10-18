OmbuLabs::Auth::Engine.routes.draw do
  devise_for :users, class_name: User, module: :devise
end
