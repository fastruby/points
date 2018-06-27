Rails.application.routes.draw do

  resources :estimates
  resources :stories
  devise_for :users
  root 'home#index'
  get 'home/index'
  resources :projects
  get 'stories/new'
  get 'stories/show'
  get 'estimates/new'
  get 'estimates/show'
end
