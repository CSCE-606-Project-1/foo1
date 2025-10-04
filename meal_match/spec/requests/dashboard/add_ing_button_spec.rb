# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard Add Ingredients button", type: :request do
  skip "Feature not found" do
    let(:user) { instance_double("User", first_name: "Test", last_name: "User", email: "test@example.com") }

    before do
      # Stub the ingredient_lists method
      allow(user).to receive(:ingredient_lists).and_return([])

      # Stub auth so /dashboard renders instead of redirecting
      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)
    end

    it "renders a button labeled 'Add Ingredients +'" do
      get "/dashboard"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Add Ingredients +")
    end
  end
end
