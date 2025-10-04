# Model representing a recipe saved by a user.
#
# @!attribute [rw] user
#   @return [User] the user who saved the recipe
# @!attribute [rw] meal_id
#   @return [String] the external meal ID
# @!attribute [rw] name
#   @return [String] the name of the recipe
# @!attribute [rw] thumbnail
#   @return [String] the thumbnail URL
# @!attribute [rw] category
#   @return [String] the recipe category
# @!attribute [rw] area
#   @return [String] the recipe area
# @!attribute [rw] description
#   @return [Text] the recipe description
class SavedRecipe < ApplicationRecord
  # The user who saved the recipe.
  #
  # @return [User]
  belongs_to :user

  # Validates presence and uniqueness of meal_id scoped to user.
  validates :meal_id, presence: true, uniqueness: { scope: :user_id }
end
