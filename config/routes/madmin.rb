# Below are the routes for madmin
namespace :madmin do
  resources :projects, except: [:update, :edit, :create]
  resources :stories
  resources :estimates, except: [:update, :edit, :create]
  resources :users, except: [:update, :edit, :create]
  root to: "dashboard#show"
end
