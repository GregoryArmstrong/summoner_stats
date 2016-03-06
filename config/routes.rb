Rails.application.routes.draw do

  get 'champions/index'

  root to: 'welcome#index'
  get '/auth/twitter', as: :twitter_login
  get '/auth/twitter/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: :logout
  post '/login', to: 'sessions#create'

  resources :users, only: [:new, :create, :show, :update, :edit] do
    resources :master_league, only: [:index, :show]
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :champions, only: [:index]

end
