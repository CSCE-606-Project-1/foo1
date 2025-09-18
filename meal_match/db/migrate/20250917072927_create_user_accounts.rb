class CreateUserAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :user_accounts do |t|
      t.timestamps

      # Relationship to User, a user may have multiple user accounts
      # TODO: We mention such DB relationships in model classes too, isn't
      # that a violation of DRY ? Figure out why this is so and if repetition
      # is not needed where can we avoid rewriting DB relations
      t.belongs_to :user, null: false, foreign_key: true

      # Fields added manually (i.e. not rails)
      t.string :auth_protocol, default = "oauth2"

      # E.g. in our case google_oauth2
      t.string :provider
      t.string :provider_account_id

      # TODO: Figure if this is needed for our app (Is the access token
      # actually used ? If so, how ?)
      t.string :access_token
      t.string :token_type, default: "Bearer"
      t.string :scope
      t.string :refresh_token
      t.datetime :expires_at # Token expires at ?
    end
  end
end
