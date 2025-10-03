class CreateIngredientListItems < ActiveRecord::Migration[8.0]
  # Migration to create join table records that link ingredient lists and
  # ingredients.
  def change
    create_table :ingredient_list_items do |t|
      t.timestamps
    end
  end
end
