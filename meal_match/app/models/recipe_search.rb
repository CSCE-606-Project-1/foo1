class RecipeSearch < ApplicationRecord
  belongs_to :ingredient_list, optional: true
end
