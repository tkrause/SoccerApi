Rails.application.routes.draw do

  root to: redirect('/docs')
  post 'login', to: 'authentication#login'

  # users
  resource :users, only: :create
  get 'users/current', to: 'users#current_user'

  # teams

end
