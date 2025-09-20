# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe "Ingredient search endpoint", type: :request do
  let(:user) { OpenStruct.new(first_name: "Test", last_name: "User", email: "test@example.com") }

  before do
    # ensure we don't accidentally hit real API
    ENV['FDC_API_KEY'] = 'DUMMY'
  end

  after do
    ENV.delete('FDC_API_KEY')
  end

  it "redirects unauthenticated users to login" do
    get "/ingredient_search", params: { q: "banana" }
    expect(response).to redirect_to(login_path)
  end

  it "returns JSON array of foods for authenticated users" do
    # Stub auth so controller thinks we're signed in
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    # Prepare fake HTTP success response from FDC
    json = { "foods" => [ { "fdcId" => 1, "description" => "BANANA", "brandOwner" => nil } ] }.to_json

    fake = Struct.new(:body) do
      def is_a?(klass)
        klass == Net::HTTPSuccess
      end
    end.new(json)

    allow(Net::HTTP).to receive(:get_response).and_return(fake)

    get "/ingredient_search", params: { q: "banana" }, headers: { "Accept" => "application/json" }

    expect(response).to have_http_status(:ok)
    parsed = JSON.parse(response.body)
    expect(parsed).to be_an(Array)
    expect(parsed.first["fdcId"]).to eq(1)
    expect(parsed.first["description"]).to eq("BANANA")
  end
end
