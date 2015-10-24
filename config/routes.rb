Rails.application.routes.draw do
  
  root 'pages#home'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  
  resources :users, except: [:delete]
  resources :artists 
  resources :cities, except: [:delete]
  resources :events, except: [:delete]

  get '/login', to: 'logins#new'
  post '/login', to: 'logins#create'
  get '/logout', to: 'logins#destroy'

  get '/search_artist', to: 'artists#new'
  get '/search_artist/:id', to: 'artist#create'
  post '/search', to: 'artists#search'
  get '/add_artist', to: 'artists#create'
end
