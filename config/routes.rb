Rails.application.routes.draw do
  get 'dashboard/index'

  devise_for :users
  root 'home#index'
  get 'home/index'
end
