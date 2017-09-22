Rails.application.routes.draw do

  root 'static_pages#home'
  
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  
  get '/signup' => 'users#new'
  post '/signup' => 'users#create'
  get '/users/:id/edit' => 'users#edit'
  patch '/users/:id' => 'users#update' 
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
