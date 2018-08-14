Rails.application.routes.draw do

  devise_for :users
  root 'home#index'
  get 'home/index'
  get 'reports/index'

  resources :projects do
    resource :report
  end

  resources :projects do
    resources :stories do
      resources :estimates
    end
  end
end
