require "rails_helper"

RSpec.describe ApplicationMailer, type: :mailer do
  it "uses the configured default sender and layout" do
    expect(described_class.default[:from]).to eq("from@example.com")
    expect(described_class._layout).to eq("mailer")
  end
end
