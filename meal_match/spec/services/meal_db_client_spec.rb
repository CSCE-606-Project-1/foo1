require 'rails_helper'

RSpec.describe MealDbClient, type: :model do
  let(:base_url) { 'https://www.themealdb.com/api/json/v2' }
  let(:api_key)  { 'testkey' }

  before do
    allow(ENV).to receive(:fetch).with('THEMEALDB_API_BASE', anything).and_return(base_url)
    allow(ENV).to receive(:fetch).with('THEMEALDB_API_KEY').and_return(api_key)
  end

  describe '.filter_by_ingredients' do
    it 'returns [] when given nil or empty ingredients' do
      expect(described_class.filter_by_ingredients(nil)).to eq([])
      expect(described_class.filter_by_ingredients([])).to eq([])
    end

    it 'parses a successful filter response into simplified meal hashes' do
      stub_request(:get, %r{#{base_url}/#{api_key}/filter\.php\?i=Chicken,Onion})
        .to_return(
          body: {
            "meals" => [
              {
                "idMeal" => "1234",
                "strMeal" => "Test Meal",
                "strMealThumb" => "https://example.com/thumb.jpg"
              }
            ]
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      result = described_class.filter_by_ingredients([ 'Chicken', 'Onion' ])
      expect(result).to be_an(Array)
      expect(result.size).to eq(1)
      expect(result.first[:id]).to eq('1234')
      expect(result.first[:name]).to eq('Test Meal')
      expect(result.first[:thumb]).to eq('https://example.com/thumb.jpg')
    end

    it 'returns empty array on non-successful HTTP response' do
      stub_request(:get, %r{#{base_url}/#{api_key}/filter\.php.*})
        .to_return(status: 500)

      expect(described_class.filter_by_ingredients([ 'Salt' ])).to eq([])
    end

    it 'returns empty array when API returns no meals' do
      stub_request(:get, %r{#{base_url}/#{api_key}/filter\.php.*})
        .to_return(
          body: { "meals" => nil }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      expect(described_class.filter_by_ingredients([ 'Pepper' ])).to eq([])
    end
  end
end
