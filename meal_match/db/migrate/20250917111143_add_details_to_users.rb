class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  # Migration to add basic user profile fields to the users table.
  def change
    add_column :users, :email, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end
end
