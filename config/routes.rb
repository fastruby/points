Rails.application.routes.draw do
  get 'home/index'
  get '*path' => "home#index"

  root :to => "home#index"
  
end
