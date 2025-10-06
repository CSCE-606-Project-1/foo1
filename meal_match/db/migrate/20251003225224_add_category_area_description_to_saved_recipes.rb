# Migration to add category, area, and description columns to saved_recipes.
class AddCategoryAreaDescriptionToSavedRecipes < ActiveRecord::Migration[8.0]
  # Adds category, area, and description columns to saved_recipes.
  #
  # @return [void]
  def change
    add_column :saved_recipes, :category, :string
    add_column :saved_recipes, :area, :string
    add_column :saved_recipes, :description, :text
  end
end
