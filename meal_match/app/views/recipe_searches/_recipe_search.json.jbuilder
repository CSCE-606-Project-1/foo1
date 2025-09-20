json.extract! recipe_search, :id, :ingredients, :created_at, :updated_at
json.url recipe_search_url(recipe_search, format: :json)
