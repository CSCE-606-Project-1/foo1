# frozen_string_literal: true

require "rails_helper"

RSpec.describe LoginController, type: :controller do
  describe "DELETE #destroy" do
    before { session[:user_id] = 42 }

    it "clears session and redirects to root" do
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(flash[:notice]).to eq("Logged out successfully")
      expect(response).to redirect_to(root_path)
    end
  end
end
