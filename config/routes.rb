Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "students#welcome"  

  get '/signup', to: 'auth#new_signup', as: :new_signup
  get '/login', to: 'auth#new_login', as: :new_login
  delete '/logout', to: 'auth#logout', as: :logout
  
  get '/about', to: 'pages#about' 
  get '/myclub', to: 'clubs#my_club', as: :my_club
  get '/contact', to: 'pages#contact'

  post '/signup', to: 'auth#signup'
  post '/login', to: 'auth#login'


  resources :students
  resources :clubs
  resources :events
  resources :registers

  # match '*path', to: 'application#not_found', via: :all
end
