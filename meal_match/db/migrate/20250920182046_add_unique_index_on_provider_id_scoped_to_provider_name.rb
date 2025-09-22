class AddUniqueIndexOnProviderIdScopedToProviderName < ActiveRecord::Migration[8.0]
  def change
    add_index :ingredients, [ :provider_name, :provider_id ], unique: true
  end
end
