Rails.application.routes.draw do
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
  # Dedicated page for adding ingredients (modal moved to its own route)
  # legacy add-ingredients path kept for backward compatibility; route to
  # the ingredient lists show page which renders the add-ingredients UI.
  get "/add-ingredients", to: "ingredient_lists#add_ingredients", as: :add_ingredients
  # Prefer the ingredient list show page which displays the add-ingredients UI
  get "/ingredient-list", to: "ingredient_lists#show", as: :ingredient_list
  # Endpoint for ingredient search used by the add-ingredients UI (AJAX)
  # and by the no-JS fallback (HTML). Routed to IngredientListsController.
  get "/ingredient_search", to: "ingredient_lists#ingredient_search", as: :ingredient_search

  resources :ingredient_lists, only: [ :index, :create, :destroy, :show ]

  get "/recipes/ingredient_lists/:ingredient_list_id",
      to: "recipes#search",
      as: :recipes_search_path

  # Redirect the root path to the login page
  root "login#new"
end
