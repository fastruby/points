Rails.application.routes.draw do
  draw :madmin

  mount OmbuLabs::Auth::Engine, at: "/", as: "ombu_labs_auth"

  authenticated do
    root to: "projects#index", as: :authenticated_root
  end

  root to: "home#index"
  get "home/index"
  get "reports/index"

  resources :stories do
    member do
      patch :approve
      patch :reject
      patch :pending
    end

    collection do
      post :bulk_destroy, to: "stories#bulk_destroy"
      post :render_markdown
    end
  end

  resources :projects do
    member do
      patch :sort
      patch :sort_stories
      patch :toggle_archive
      patch :toggle_locked
      get :new_clone
      post :clone
      get :open_delete_modal
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
      resources :comments, only: [:create, :edit, :update, :destroy]
    end
    resource :action_plan, only: [:show]
  end
end
