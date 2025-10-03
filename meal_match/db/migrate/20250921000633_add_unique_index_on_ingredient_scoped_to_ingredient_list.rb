class AddUniqueIndexOnIngredientScopedToIngredientList < ActiveRecord::Migration[8.0]
  # Add a unique index ensuring ingredient list items are unique per list.
  def change
    add_index :ingredient_list_items, [ :ingredient_list_id, :ingredient_id ], unique: true
  end
end
