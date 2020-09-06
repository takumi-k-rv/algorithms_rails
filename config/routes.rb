Rails.application.routes.draw do
  get 'bookmarks/create'
  get 'bookmarks/destroy'
  get "/" => "posts#index"
  resources :posts
  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"
  resources :users

  post "bookmarks/:post_id/create" => "bookmarks#create"
  post "bookmarks/:post_id/destroy" => "bookmarks#destroy"
end
