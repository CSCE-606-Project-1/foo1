class CreateIngredientLists < ActiveRecord::Migration[8.0]
  # Migration to create a container table for user-created ingredient lists.
  def change
    create_table :ingredient_lists do |t|
      t.string :title
      t.timestamps
    end
  end
end
