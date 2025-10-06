require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  it "uses the default from address" do
    expect(described_class.default[:from]).to eq("from@example.com")
  end
end
