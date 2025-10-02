# Application user.
class User < ApplicationRecord
  #
  # @!attribute user_accounts
  #   @return [Array<UserAccount>]
  # @!attribute ingredient_lists
  #   @return [Array<IngredientList>]
  has_many :user_accounts, dependent: :destroy
  has_many :ingredient_lists, dependent: :destroy
end
