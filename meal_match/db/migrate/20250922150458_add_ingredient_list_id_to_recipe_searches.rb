class AddIngredientListIdToRecipeSearches < ActiveRecord::Migration[8.0]
  def change
    add_reference :recipe_searches, :ingredient_list, foreign_key: true, null: true
  end
end
