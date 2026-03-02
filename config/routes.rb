Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :decor_items, only: [:index, :show] do
    resources :reviews, only: [:create, :update, :destroy]
  end

  resources :categories, only: [:show], param: :slug
  
  resource :cart, only: [:show] do
    member do
      post :add_item
      delete :remove_item
      patch :update_quantity
      post :clear
    end
  end

  # Defines the root path route ("/")
  # root "decor_items#index"
  root 'home#index'
end
