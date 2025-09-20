Rails.application.routes.draw do
<<<<<<< HEAD
=======
  resources :recipe_searches
>>>>>>> 3e7438f (one ingredient recipe feature, cucumber testing one scenario for said feature)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # The as: :something allows developers to write something_path when
  # the want to refer to this end point
<<<<<<< HEAD
  get    '/login', to: 'login#new', as: :login
  delete '/logout', to: 'login#destroy', as: :logout
=======
  get    "/login", to: "login#new", as: :login
  delete "/logout", to: "login#destroy", as: :logout
>>>>>>> 3e7438f (one ingredient recipe feature, cucumber testing one scenario for said feature)

  # OAuth related route
  namespace :oauth do
    namespace :google_oauth2 do
      # Corresponds to /oauth/google_oauth2/callback which corresponds
      # maps to the call OAuth::GoogleOauth2#callback which is a controller
      # class method that we have to define
      get "callback"
    end
  end

  # Dashboard related (after login)
<<<<<<< HEAD
  get '/dashboard', to: 'dashboard#show', as: :dashboard
=======
  get "/dashboard", to: "dashboard#show", as: :dashboard
>>>>>>> 3e7438f (one ingredient recipe feature, cucumber testing one scenario for said feature)
end
