require 'rails_helper'
RSpec.describe Ingredient, type: :model do
  after(:each) do
    Ingredient.destroy_all
  end
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
    REQUIRED_FIELDS = [ :provider_name, :provider_id, :title ]
    REQUIRED_FIELDS.each do |field|
      it "is invalid without the #{field}" do
        i = Ingredient.new(valid_attributes.except(field))
        expect(i).to be_invalid
        expect(i.errors[field]).to include("can't be blank")
      end
    end

    it "should validate uniqueness of a provider id given a provider name" do
      # create saves it to database, new just in memory.

      # For a given provider, such as meal db, the id provided to an
      # ingredient (e.g. 1234) should be unique.
      i1 = Ingredient.create!(valid_attributes)
      expect(i1).to be_valid

      # Duplicate provider id given same provider name should not work
      i2_attr = {
        provider_name: valid_attributes[:provider_name],
        provider_id: valid_attributes[:provider_id],
        title: valid_attributes[:title] + "something more"
      }

      i2 = Ingredient.new(i2_attr)
      expect(i2).to be_invalid
      expect(i2.errors[:provider_id]).to include(" must be unique within provider_name")

      # Same provider id given a different provider name should work
      i3_attr = {
        provider_name: valid_attributes[:provider_name] + "extra",
        provider_id: valid_attributes[:provider_id],
        title: valid_attributes[:title]
      }

      i3 = Ingredient.new(i3_attr)
      expect(i3).to be_valid
    end
  end
end
