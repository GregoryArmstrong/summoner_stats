Rails.application.routes.draw do

  get 'dashboards/index'

  root to: 'welcome#index'
  get '/auth/twitter', as: :login
  get '/auth/twitter/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: :logout

  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create, :destroy]

end
