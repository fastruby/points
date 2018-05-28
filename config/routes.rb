Rails.application.routes.draw do
  get 'home/index'

 root 'application#hello'
end
