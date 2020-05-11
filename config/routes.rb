Rails.application.routes.draw do
  
  root to: 'pages#index'
  get 'pages/about', to: 'pages#about', as: "about"
  get 'pages/contact', to: "pages#contact", as: "contact"
  resources :artworks

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
