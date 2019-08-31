Rails.application.routes.draw do

  root to: redirect('/docs')
  post 'authenticate', to: 'authentication#authenticate'
  get 'user', to: 'authentication#user'

end
