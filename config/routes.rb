Rails.application.routes.draw do
  resources :posts
  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"
  resources :users
end
