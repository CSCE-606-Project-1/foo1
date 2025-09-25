require "rails_helper"

RSpec.describe "Root route", type: :routing do
  it "routes / to login#new" do
    expect(get: "/").to route_to("login#new")
  end
end
