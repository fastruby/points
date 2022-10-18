OmbuLabs::Auth::Engine.routes.draw do
  devise_for :users, class_name: "OmbuLabs::Auth::User", module: :devise
end
