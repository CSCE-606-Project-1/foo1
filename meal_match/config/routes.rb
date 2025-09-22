Rails.application.routes.draw do
  get "saved_recipes/index"
  get "saved_recipes/create"
  get "saved_recipes/destroy"
  resources :recipe_searches
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
  get    "/login", to: "login#new", as: :login
  delete "/logout", to: "login#destroy", as: :logout

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
  get "/dashboard", to: "dashboard#show", as: :dashboard

  # Redirect to show recipes if function called by ingredient list ID
  get "/recipe_searches/id/:id", to: "ingredient_list_recipes#show", as: :ingredient_list_recipes

  # Routes for saved recipes
  resources :saved_recipes, only: [ :index, :create, :destroy ]
end
