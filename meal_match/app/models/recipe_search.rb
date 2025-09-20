class RecipeSearch < ApplicationRecord
  validates :ingredients, presence: true
end
