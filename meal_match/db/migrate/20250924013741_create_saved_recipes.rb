# Migration to create the saved_recipes table.
class CreateSavedRecipes < ActiveRecord::Migration[8.0]
  # Creates the saved_recipes table.
  #
  # @return [void]
  def change
    create_table :saved_recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :meal_id
      t.string :name
      t.string :thumbnail

      t.timestamps
    end
  end
end
