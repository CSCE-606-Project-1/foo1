class AddReferencesToIngredientListItems < ActiveRecord::Migration[8.0]
  # Add foreign key references for ingredient list items to the appropriate
  # parent tables.
  def change
    add_reference :ingredient_list_items, :ingredient_list, null: false, foreign_key: true
    add_reference :ingredient_list_items, :ingredient, null: false, foreign_key: true
  end
end
