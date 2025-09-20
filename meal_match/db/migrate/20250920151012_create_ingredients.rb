class CreateIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredients do |t|
      t.string :provider_name
      t.string :provider_id
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
