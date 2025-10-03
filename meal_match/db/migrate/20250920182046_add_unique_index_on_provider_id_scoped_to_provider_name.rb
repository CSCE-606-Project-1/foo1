class AddUniqueIndexOnProviderIdScopedToProviderName < ActiveRecord::Migration[8.0]
  # Add a unique index to ingredients to ensure provider_id is unique per
  # provider_name.
  def change
    add_index :ingredients, [ :provider_name, :provider_id ], unique: true
  end
end
