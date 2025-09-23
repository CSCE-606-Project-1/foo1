class AddUserIdAsForeignKeyToIngredientLists < ActiveRecord::Migration[8.0]
  def change
    add_reference :ingredient_lists, :user, null: false, foreign_key: true
  end
end
