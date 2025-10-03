# A user's saved collection of ingredients. Ingredient lists are used as the
# basis for recipe searches and UI selection flows.
class IngredientList < ApplicationRecord
  # A collection of ingredients created by a user. Typically used as the
  # basis for recipe searches.
  #
  # @!attribute user
  #   @return [User]
  belongs_to :user

  has_many :ingredient_list_items, dependent: :destroy
  has_many :ingredients, through: :ingredient_list_items

  validates :title, presence: true
end
