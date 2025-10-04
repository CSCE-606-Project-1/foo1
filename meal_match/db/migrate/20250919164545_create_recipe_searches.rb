# Migration to create the recipe_searches table.
class CreateRecipeSearches < ActiveRecord::Migration[8.0]
  # Creates the recipe_searches table.
  #
  # @return [void]
  def change
    create_table :recipe_searches do |t|
      t.text :ingredients

      t.timestamps
    end
  end
end
