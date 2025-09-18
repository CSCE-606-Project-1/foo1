class User < ApplicationRecord
  has_many :user_accounts, dependent: :destroy
end
