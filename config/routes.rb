Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :products, only: [:index, :show], param: :slug do
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
      post :create_payment_intent
    end
    member do
      get :confirmation
    end
  end

  root 'home#index'

  namespace :api do
    namespace :v1 do
      resources :products, only: [:index, :show], param: :slug
    end
  end
end
