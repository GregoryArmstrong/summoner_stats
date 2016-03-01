Rails.application.routes.draw do

  root to: 'welcome#index'
  get '/auth/twitter', as: :twitter_login
  get '/auth/twitter/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: :logout
  post '/login', to: 'sessions#create'

  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create, :destroy]

end
