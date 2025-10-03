class AddCategoryAreaDescriptionToSavedRecipes < ActiveRecord::Migration[8.0]
  def change
    add_column :saved_recipes, :category, :string
    add_column :saved_recipes, :area, :string
    add_column :saved_recipes, :description, :text
  end
end
