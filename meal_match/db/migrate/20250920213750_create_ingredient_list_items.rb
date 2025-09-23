class CreateIngredientListItems < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredient_list_items do |t|
      t.timestamps
    end
  end
end
