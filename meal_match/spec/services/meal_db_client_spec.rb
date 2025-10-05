# Spec that verifies MealDbClient's HTTP interactions and response parsing.
# Exercises filter/list endpoints and asserts correct mapping of TheMealDB JSON
# responses into simplified meal hashes used by the application.
#
# @param format [Symbol] example placeholder for documentation consistency
# @return [void] test examples assert parsing and error handling behavior
# def to_format(format = :html)
#   # format the spec description (example placeholder for YARD)
# end
#
require "rails_helper"
require "net/http"

RSpec.describe MealDbClient, type: :service do
  before do
    # mock response object
    fake_response = double("response", is_a?: Net::HTTPSuccess, body: response_body)

    # mock Net::HTTP instance with proper setter support
    fake_http = double("http").as_null_object
    allow(fake_http).to receive(:request).and_return(fake_response)
    allow(fake_http).to receive(:use_ssl=)
    allow(fake_http).to receive(:open_timeout=)
    allow(fake_http).to receive(:read_timeout=)

    # intercept Net::HTTP.new
    allow(Net::HTTP).to receive(:new).and_return(fake_http)

    # mock ENV vars
    allow(ENV).to receive(:fetch).with("THEMEALDB_API_BASE", anything)
                                 .and_return("https://www.themealdb.com/api/json/v2")
    allow(ENV).to receive(:fetch).with("THEMEALDB_API_KEY").and_return("demo")
  end

  let(:response_body) do
    {
      "meals" => [
        { "idIngredient" => "1", "strIngredient" => "Chicken", "strDescription" => "Protein" },
        { "idIngredient" => "2", "strIngredient" => "Onion", "strDescription" => "Vegetable" }
      ]
    }.to_json
  end

describe ".fetch_all_ingredients" do
  before do
    # clear memoized cache before each example
    described_class.instance_variable_set(:@ingredients_cache, nil)
  end

  it "parses API response into array of hashes" do
    result = described_class.fetch_all_ingredients
    expect(result).to be_an(Array)
    expect(result.first).to include(:id, :name, :description)
  end

  it "returns [] when HTTP fails" do
    described_class.instance_variable_set(:@ingredients_cache, nil)
    bad_response = double("response", is_a?: false)
    bad_http = double("http").as_null_object
    allow(bad_http).to receive(:request).and_return(bad_response)
    allow(Net::HTTP).to receive(:new).and_return(bad_http)

    result = described_class.fetch_all_ingredients
    expect(result).to eq([])
  end

  it "raises error when API key missing" do
    described_class.instance_variable_set(:@ingredients_cache, nil)
    allow(ENV).to receive(:fetch).with("THEMEALDB_API_BASE", anything)
                                 .and_return("https://www.themealdb.com/api/json/v2")
    allow(ENV).to receive(:fetch).with("THEMEALDB_API_KEY").and_raise(KeyError)
    expect { described_class.fetch_all_ingredients }.to raise_error(KeyError)
  end
end


  describe ".search_ingredients" do
    it "returns [] for blank query" do
      expect(described_class.search_ingredients(" ")).to eq([])
    end

    it "returns matches case-insensitively" do
      allow(described_class).to receive(:fetch_all_ingredients).and_return([
        { name: "Chicken" }, { name: "Onion" }, { name: "Garlic" }
      ])
      result = described_class.search_ingredients("chick")
      expect(result.map { |h| h[:name] }).to include("Chicken")
    end
  end

  describe ".filter_by_ingredients" do
    it "returns [] for empty input" do
      expect(described_class.filter_by_ingredients([])).to eq([])
    end

    it "handles HTTP failure safely" do
      fail_response = double("response", is_a?: false)
      http_double = double("http").as_null_object
      allow(http_double).to receive(:request).and_return(fail_response)
      allow(Net::HTTP).to receive(:new).and_return(http_double)

      expect(described_class.filter_by_ingredients([ "Chicken" ])).to eq([])
    end

    it "parses valid meal list" do
      meal_body = {
        "meals" => [
          { "idMeal" => "9", "strMeal" => "Test Meal", "strMealThumb" => "http://x" }
        ]
      }.to_json
      success = double("response", is_a?: true, body: meal_body)
      http = double("http").as_null_object
      allow(http).to receive(:request).and_return(success)
      allow(Net::HTTP).to receive(:new).and_return(http)

      meals = described_class.filter_by_ingredients([ "Egg" ])
      expect(meals.first[:name]).to eq("Test Meal")
      expect(meals.first[:id]).to eq("9")
    end

    it "returns [] when StandardError raised" do
      allow(Net::HTTP).to receive(:new).and_raise(StandardError)
      expect(described_class.filter_by_ingredients([ "Egg" ])).to eq([])
    end
  end
end
