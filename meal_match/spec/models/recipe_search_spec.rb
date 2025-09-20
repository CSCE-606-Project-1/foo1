require 'rails_helper'

RSpec.describe RecipeSearch, type: :model do
  it "is valid with ingredients" do
    expect(RecipeSearch.new(ingredients: "chicken_breast")).to be_valid
  end

  it "is invalid without ingredients" do
    search = RecipeSearch.new(ingredients: nil)
    expect(search).not_to be_valid
  end
end
