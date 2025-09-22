class CreateIngredientLists < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredient_lists do |t|
      t.string :title
      t.timestamps
    end
  end
end
