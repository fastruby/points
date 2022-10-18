Rails.application.routes.draw do
  mount OmbuLabs::Auth::Engine => "/ombu_labs-auth"
end
