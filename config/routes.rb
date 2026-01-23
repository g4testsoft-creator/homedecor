Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :decor_items, only: [:index]

  # Defines the root path route ("/")
  root "decor_items#index"
end
