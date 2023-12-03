Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "main#index"

  get "/messages/search", to: "messages#search"

  resources :messages, path_names: { new: 'new/:user_id' }

  resources :users
  get "/users/:id/confirm/:code", to: "users#confirm"

end
