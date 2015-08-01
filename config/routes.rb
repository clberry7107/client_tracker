Rails.application.routes.draw do
  

  
  root 'pages#home'

  resources :users, except: [:delete]


end
