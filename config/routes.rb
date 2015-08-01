Rails.application.routes.draw do
  
  root 'pages#home'

  get '/register', to: 'users#new'
  resources :users, except: [:delete]


end
