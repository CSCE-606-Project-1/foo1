class CreateIngredients < ActiveRecord::Migration[8.0]
  # Migration to create the ingredients table used to store provider-backed
  # ingredient metadata.
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
