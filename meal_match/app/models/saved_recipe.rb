class SavedRecipe < ApplicationRecord
  belongs_to :user
  validates :meal_id, presence: true, uniqueness: { scope: :user_id }
end
