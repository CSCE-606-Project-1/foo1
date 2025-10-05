require 'rails_helper'

RSpec.describe UserAccount, type: :model do
  let(:user) { User.create!(first_name: "A", last_name: "B", email: "a@b.com") }

  it "detects expired account" do
    account = described_class.new(user:, expires_at: 1.day.ago)
    expect(account.expired?).to be true
  end

  it "detects non-expired account" do
    account = described_class.new(user:, expires_at: 1.day.from_now)
    expect(account.expired?).to be false
  end
end
