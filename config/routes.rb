Rails.application.routes.draw do
  
  root 'pages#home'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  
  resources :users, except: [:delete]

  get '/login', to: 'logins#new'
  post '/login', to: 'logins#create'
  get '/logout', to: 'logins#destroy'

  get '/search_artist', to: 'artists#new'
  post '/search', to: 'artists#search'
end
