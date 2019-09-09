Rails.application.routes.draw do

  root to: redirect('/docs')
  post 'login', to: 'authentication#login'

  # users
  resource :users, only: :create
  get 'users/current', to: 'users#current_user'

  # teams
  get 'teams/all', to: 'teams#all'
  resources :teams do
    resources :users, controller: 'teams_users'
  end
end
