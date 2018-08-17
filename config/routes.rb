Rails.application.routes.draw do

  devise_for :users
  authenticated do
    root :to => 'projects#index'
  end

  root :to => 'home#index'
  get 'home/index'
  resources :projects do
    resources :stories do
      resources :estimates
    end
  end
end
