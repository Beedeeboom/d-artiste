Rails.application.routes.draw do
  
  get 'orders/new'
  resources :arts
  devise_for :users
  root to: 'pages#index'
  get 'pages/about', to: 'pages#about', as: "about"
  get 'pages/contact', to: "pages#contact", as: "contact"
  get 'pages/buy', to: "pages#buy", as: "buy"
  resources :users
  get 'orders/new', to: "orders#new", as: "new_order"
  get 'orders/buy', to: "orders#buy", as: "buy_order"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
