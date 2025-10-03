require "rails_helper"

RSpec.describe UserAccount do
  describe "#expired?" do
    let(:user) { User.create!(email: "test@example.com") }

    it "returns true when the expiration is in the past" do
      account = described_class.new(user: user, expires_at: 5.minutes.ago)
      expect(account).to be_expired
    end

    it "returns false when the expiration is in the future" do
      account = described_class.new(user: user, expires_at: 5.minutes.from_now)
      expect(account).not_to be_expired
    end
  end
end
