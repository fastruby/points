Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "callbacks"}

  authenticated do
    root to: "projects#index", as: :authenticated_root
  end

  root to: "home#index"
  get "home/index"
  get "reports/index"

  resource :stories do
    post :bulk_destroy, to: "stories#bulk_destroy"
  end

  resources :projects do
    patch :sort, on: :member
    patch :toggle_archive, on: :member
    get :new_sub_project

    resource :report do
      get "download", to: "reports#download"
    end
    resources :stories do
      get :real_scores, on: :collection, to: "real_scores#edit"
      patch :real_scores, on: :collection, to: "real_scores#update"
      patch :import, on: :collection
      get :export, on: :collection
      resources :estimates
    end
    resource :action_plan, only: [:show]
  end
end
