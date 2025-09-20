require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  let(:valid_attributes) do
    {
      # Identification of the provider
      provider_name: "mealdb",

      # Id provided by the provider to the ingredient in
      # their API
      provider_id: "1234",

      title: "Egg",
      description: "Great for protein, laid by hens/goats"
    }
  end

  describe "happy paths" do
    # The happy path provides all fields properly and test
    # that not providing optional fields should also work
    # well
    it "should succeed when all arguments are provided properly" do
      i = Ingredient.new(valid_attributes)
      expect(i).to be_valid
    end

    it "should succeed when optional description is not provided" do
      i = Ingredient.new(valid_attributes.except(:description))
      expect(i).to be_valid
    end
  end

  describe "validations" do
    REQUIRED_FIELDS = [:provider_name, :provider_id, :title]
    REQUIRED_FIELDS.each do |field|
      it "is invalid without the #{field}" do
        i = Ingredient.new(valid_attributes.except(field))
        expect(i).to be_invalid
        expect(i.errors[field]).to include("can't be blank")
      end
    end
  end
end
