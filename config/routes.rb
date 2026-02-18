Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :decor_items, only: [:index, :show]

  # Defines the root path route ("/")
  root "decor_items#index"
end
