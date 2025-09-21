class User < ApplicationRecord
  has_many :user_accounts, dependent: :destroy
  has_many :ingredient_lists, dependent: :destroy
end
