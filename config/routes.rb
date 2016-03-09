Rails.application.routes.draw do

  get 'champions/index'

  root to: 'welcome#index'
  get '/auth/twitter', as: :twitter_login
  get '/auth/twitter/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: :logout
  post '/login', to: 'sessions#create'
  post '/users/:user_id/master_league/comparison', to: 'master_league#comparison', as: :comparison
  post '/users/clear', to: 'users#clear', as: :clear_cache

  resources :users, only: [:new, :create, :show, :update, :edit] do
    resources :master_league, only: [:index]
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :champions, only: [:index]

end
