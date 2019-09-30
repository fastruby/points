Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }

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
      patch :import, on: :collection
      get :export, on: :collection
      resources :estimates
    end
  end
end
