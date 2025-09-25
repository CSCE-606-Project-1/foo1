require 'rails_helper'

RSpec.describe "SavedRecipes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/saved_recipes/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/saved_recipes/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/saved_recipes/destroy"
      expect(response).to have_http_status(:success)
    end
  end
end
