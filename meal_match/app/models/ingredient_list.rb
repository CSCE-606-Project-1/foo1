class IngredientList < ApplicationRecord
  belongs_to :user

  has_many :ingredient_list_items, dependent: :destroy
  has_many :ingredients, through: :ingredient_list_items

  validates :title, presence: true
end
