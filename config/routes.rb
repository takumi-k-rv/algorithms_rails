Rails.application.routes.draw do
  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"
  resources :users
end
