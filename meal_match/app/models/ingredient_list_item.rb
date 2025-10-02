# Join model that connects IngredientList and Ingredient.
class IngredientListItem < ApplicationRecord
  # Maps the many to many association between ingredient list and ingredient.
  #
  # @!attribute ingredient_list
  #   @return [IngredientList]
  # @!attribute ingredient
  #   @return [Ingredient]
  belongs_to :ingredient_list
  belongs_to :ingredient

  # Given an ingredient list, the ingredient must be unique
  validates :ingredient_id, uniqueness: {
                              scope: :ingredient_list_id,
                              message: " must be unique within ingredient list"
                            }
end
