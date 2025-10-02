class Ingredient < ApplicationRecord
  THEMEALDB_PROVIDER = "themealdb".freeze

  has_many :ingredient_list_items, dependent: :destroy
  has_many :ingredient_lists, through: :ingredient_list_items

  validates :provider_name, presence: true
  validates :provider_id, presence: true
  validates :title, presence: true

  # Provider id (i.e of an ingredient stored/given by the provider) should
  # be unique for a given provider (Provider name)
  validates :provider_id, uniqueness: {
                            scope: :provider_name,
                            message: " must be unique within provider_name"
                          }
end
