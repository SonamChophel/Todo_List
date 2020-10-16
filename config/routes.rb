Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show, :update, :destroy]

  #users routes
  get "/show_all", to: "users#show_all"
  post "/register", to: "users#register"
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
  get "/users/:id", to: "users#show"
  patch "/users/:id", to: "users#update"
  delete "/users/:id", to: "users#destroy"
  delete "/logout", to: "users#logout"


  #list routes
  get "/users/:user_id/show_lists", to: "lists#show_all"
  get "/users/:user_id/show_list", to: "lists#show"
  get "/users/:user_id/completed_list", to: "lists#completed_list"
  get "/users/:user_id/incomplete_list", to: "lists#incomplete_list"
  post "/users/:user_id/lists", to: "lists#create"
  put "/users/:user_id/lists/:list_id", to: "lists#update"
  delete "/users/:user_id/lists/:list_id", to: "lists#destroy"


  #password routes
  post "/passwords/forgot", to: "passwords#forgot"
  post "/passwords/reset", to: "passwords#reset"
  patch "/passwords/update", to: "passwords#update"
end
