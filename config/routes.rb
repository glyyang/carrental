Rails.application.routes.draw do
  root 'static_pages#home'
  # get 'static_pages/home'
  get '/signup' => 'users#new'
  post '/signup' => 'users#create'
  post '/users/:id' => 'users#update'

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
