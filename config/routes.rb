Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }
  authenticated do
    root :to => 'projects#index'
  end

  root :to => 'home#index'
  get 'home/index'
  get 'reports/index'

  resources :projects do
    patch :sort, on: :member

    resource :report

    resources :stories do
      resources :estimates
    end
  end
end
