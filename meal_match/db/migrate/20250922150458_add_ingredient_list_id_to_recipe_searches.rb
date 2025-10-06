# Migration to add ingredient_list_id reference to recipe_searches.
class AddIngredientListIdToRecipeSearches < ActiveRecord::Migration[8.0]
  # Adds ingredient_list reference to recipe_searches.
  #
  # @return [void]
  def change
    add_reference :recipe_searches, :ingredient_list, foreign_key: true, null: true
  end
end
