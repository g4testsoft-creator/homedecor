Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :products, only: [:index, :show] do
    collection do
      get :search
    end
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

  resources :orders, only: [:create] do
    collection do
      get :checkout
    end
    member do
      get :confirmation
    end
  end

  # Defines the root path route ("/")
  root 'home#index'
end
