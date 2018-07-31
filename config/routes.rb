Rails.application.routes.draw do

  resources :estimates
  devise_for :users
  root 'home#index'
  get 'home/index'
  resources :projects do
    resources :stories
  end
end
