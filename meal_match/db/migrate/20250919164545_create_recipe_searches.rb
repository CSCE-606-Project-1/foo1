class CreateRecipeSearches < ActiveRecord::Migration[8.0]
  def change
    create_table :recipe_searches do |t|
      t.text :ingredients

      t.timestamps
    end
  end
end
