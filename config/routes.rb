Rails.application.routes.draw do

  root to: redirect('/docs')
  post 'login', to: 'authentication#login'

  # users
  resource :users, only: :create
  get 'users/current', to: 'users#current_user'
  post 'users/search', to: 'users#search'
  post 'users/invite', to: 'users#invite'

  # teams
  get 'teams/all', to: 'teams#all'
  resources :teams do
    resources :members, controller: 'team_members'
  end

  # events / games
  resources :events
  get 'teams/:team_id/events', to: 'events#for_team'
  get '/teams/:team_id/events/recent', to: 'events#recent_game'
  get '/teams/:team_id/events/next', to: 'events#next_event'
end
