class AddUniqueIndexOnIngredientScopedToIngredientList < ActiveRecord::Migration[8.0]
  def change
    add_index :ingredient_list_items, [ :ingredient_list_id, :ingredient_id ], unique: true
  end
end
