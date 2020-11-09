Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }

  authenticated do
    root :to => 'projects#index'
  end

  root :to => 'home#index'
  get 'home/index'
  get 'reports/index'

  resource :stories do
    post :bulk_destroy, to: 'stories#bulk_destroy'
  end

  resources :projects do
    patch :sort, on: :member

    resource :report

    resources :stories do
      get :real_scores, on: :collection, to: 'real_scores#edit'
      patch :real_scores, on: :collection, to: 'real_scores#update'
      patch :import, on: :collection
      get :export, on: :collection
      resources :estimates
    end
  end
end
