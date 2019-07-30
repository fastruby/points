Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }
  authenticated do
    root :to => 'projects#index'
  end

  root :to => 'home#index'
  get 'home/index'
  get 'reports/index'

  resources :projects do
    resource :report
  end

  resources :projects do
    resources :stories do
      collection do
        patch :sort
      end
    end
    resources :stories do
      resources :estimates
    end
  end
end
