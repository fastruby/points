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
    post :render_markdown
  end

  resources :projects do
    member do
      patch :sort
      patch :sort_stories
      patch :toggle_archive
      patch :toggle_locked
      get :new_clone
      post :clone
    end
    get :new_sub_project

    resource :report do
      get "download", to: "reports#download"
    end

    resources :stories do
      get :real_scores, on: :collection, to: "real_scores#edit"
      patch :real_scores, on: :collection, to: "real_scores#update"
      patch :import, on: :collection
      get :export, on: :collection
      resources :estimates, except: [:index, :show]
      put :move
    end
    resource :action_plan, only: [:show]
  end
end
