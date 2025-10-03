require "rails_helper"

RSpec.describe LoginController, type: :controller do
  routes { Rails.application.routes }

  describe "DELETE #destroy" do
    it "clears the user session" do
      session[:user_id] = 42

      delete :destroy

      expect(session[:user_id]).to be_nil
    end
  end
end
