class UserAccount < ApplicationRecord
  belongs_to :user

  def expired?
    self.expires_at < Time.zone.now
  end
end
