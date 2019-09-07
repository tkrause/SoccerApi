Rails.application.routes.draw do

  root to: redirect('/docs')
  post 'authenticate', to: 'authentication#authenticate'
  post 'login', to: 'authentication#authenticate'

  resource :users, only: :create
  get 'users/current', to: 'users#current_user'

end
