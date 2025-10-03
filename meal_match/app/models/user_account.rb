# Represents authentication / external account information for a User.
class UserAccount < ApplicationRecord
  #
  # @!attribute user
  #   @return [User]
  belongs_to :user

  # Check whether the account has expired according to `expires_at`.
  #
  # @return [Boolean]
  def expired?
    self.expires_at < Time.zone.now
  end
end
