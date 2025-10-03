require "rails_helper"

RSpec.describe MealDbClient do
  let(:api_base) { "https://example.test/api" }
  let(:api_key) { "abc123" }
  let(:http) { instance_double(Net::HTTP) }

  before do
    @original_base = ENV["THEMEALDB_API_BASE"]
    @original_key = ENV["THEMEALDB_API_KEY"]
    ENV["THEMEALDB_API_BASE"] = api_base
    ENV["THEMEALDB_API_KEY"] = api_key
    MealDbClient.instance_variable_set(:@ingredients_cache, nil)
    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(http).to receive(:use_ssl=)
    allow(http).to receive(:open_timeout=)
    allow(http).to receive(:read_timeout=)
  end

  after do
    MealDbClient.instance_variable_set(:@ingredients_cache, nil)
    if @original_base.nil?
      ENV.delete("THEMEALDB_API_BASE")
    else
      ENV["THEMEALDB_API_BASE"] = @original_base
    end

    if @original_key.nil?
      ENV.delete("THEMEALDB_API_KEY")
    else
      ENV["THEMEALDB_API_KEY"] = @original_key
    end
  end

  describe ".fetch_all_ingredients" do
    it "returns parsed ingredient hashes and memoizes the result" do
      body = {
        "meals" => [
          { "idIngredient" => "1", "strIngredient" => "Chicken", "strDescription" => "Protein" },
          { "id" => "2", "name" => "Beef", "description" => "Red meat" }
        ]
      }.to_json
      response = instance_double("Net::HTTPResponse", body: body)
      allow(response).to receive(:is_a?) { |klass| klass == Net::HTTPSuccess }
      allow(http).to receive(:request).and_return(response)

      first_call = MealDbClient.fetch_all_ingredients
      second_call = MealDbClient.fetch_all_ingredients

      expect(first_call).to eq([
        { id: "1", name: "Chicken", description: "Protein" },
        { id: "2", name: "Beef", description: "Red meat" }
      ])
      expect(second_call).to be(first_call)
      expect(http).to have_received(:request).once
    end

    it "returns an empty array when the response is not successful" do
      response = instance_double("Net::HTTPResponse", body: "{}")
      allow(response).to receive(:is_a?) { |_klass| false }
      allow(http).to receive(:request).and_return(response)

      expect(MealDbClient.fetch_all_ingredients).to eq([])
    end

    it "swallows JSON parsing errors and returns an empty array" do
      response = instance_double("Net::HTTPResponse", body: "not json")
      allow(response).to receive(:is_a?) { |klass| klass == Net::HTTPSuccess }
      allow(http).to receive(:request).and_return(response)

      expect(MealDbClient.fetch_all_ingredients).to eq([])
    end
  end

  describe ".search_ingredients" do
    before do
      allow(MealDbClient).to receive(:fetch_all_ingredients).and_return([
        { id: "1", name: "Chicken", description: "Protein" },
        { id: "2", name: "Beef", description: "Red meat" },
        { id: "3", name: "Carrot", description: "Vegetable" }
      ])
    end

    it "returns an empty array when the query is blank" do
      expect(MealDbClient.search_ingredients(" ")).to eq([])
    end

    it "performs a case-insensitive substring search" do
      expect(MealDbClient.search_ingredients("ch")).to eq([
        { id: "1", name: "Chicken", description: "Protein" }
      ])
    end
  end

  describe ".filter_by_ingredients" do
    it "returns an empty array when provided names are blank" do
      expect(MealDbClient.filter_by_ingredients(["", nil])).to eq([])
    end

    it "returns parsed meals when the API call succeeds" do
      body = {
        "meals" => [
          { "idMeal" => "9", "strMeal" => "Chicken Curry", "strMealThumb" => "thumb.jpg" },
          { "id" => "10", "name" => "Beef Stew", "thumbnail" => "thumb2.jpg" }
        ]
      }.to_json
      response = instance_double("Net::HTTPResponse", body: body)
      allow(response).to receive(:is_a?) { |klass| klass == Net::HTTPSuccess }
      allow(http).to receive(:request).and_return(response)

      meals = MealDbClient.filter_by_ingredients(["Chicken", "Onion"])

      expect(meals).to eq([
        { id: "9", name: "Chicken Curry", thumb: "thumb.jpg" },
        { id: "10", name: "Beef Stew", thumb: "thumb2.jpg" }
      ])
    end

    it "returns an empty array when the API call fails" do
      response = instance_double("Net::HTTPResponse", body: "{}")
      allow(response).to receive(:is_a?) { |_klass| false }
      allow(http).to receive(:request).and_return(response)

      expect(MealDbClient.filter_by_ingredients(["Chicken"])).to eq([])
    end

    it "returns an empty array when an error occurs" do
      allow(http).to receive(:request).and_raise(StandardError.new("boom"))

      expect(MealDbClient.filter_by_ingredients(["Chicken"])).to eq([])
    end
  end
end
