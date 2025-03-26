Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "students#welcome"  

  get '/signup', to: 'auth#new_signup', as: :new_signup
  get '/login', to: 'auth#new_login', as: :new_login
  delete '/logout', to: 'auth#logout', as: :logout
  
  get '/about', to: 'pages#about' 
  get '/myclub', to: 'clubs#my_club', as: :my_club
  get '/contact', to: 'pages#contact'
  get '/role_upgrade', to: 'students#role_upgrade', as: :role_upgrade
  post '/verify_role_code', to: 'students#verify_role_code', as: :verify_role_code
  get '/events/:id/registrations', to: 'events#registrations', as: :event_registrations  

  post '/signup', to: 'auth#signup'
  post '/login', to: 'auth#login'

  get '/password/reset', to: 'password_resets#new'
  post '/password/reset', to: 'password_resets#create'

  get '/password/reset/edit', to: 'password_resets#edit', as: :password_reset_edit
  patch '/password/reset/edit', to: 'password_resets#update', as: :password_reset_update

  get '/registers/:id/edit', to: 'errors#not_found', via: :all

  get '/students', to: 'errors#not_found', via: :all
  get '/students/:id', to: 'errors#not_found', via: :all
  get '/students/:id/edit', to: 'errors#not_found', via: :all


  resources :students
  resources :clubs
  resources :events
  resources :registers

  match '*unmatched', to: 'errors#not_found', via: :all
end
