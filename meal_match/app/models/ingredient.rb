class Ingredient < ApplicationRecord
  validates :provider_name, presence: true
  validates :provider_id, presence: true
  validates :title, presence: true
end
