require 'rails_helper'

RSpec.describe MealDbClient, type: :model do
  describe '.filter_by_ingredients' do
    let(:base) { 'https://www.themealdb.com/api/json/v2' }
    let(:key) { 'testkey' }

    before do
      allow(ENV).to receive(:fetch).with('THEMEALDB_API_BASE', anything).and_return(base)
      allow(ENV).to receive(:fetch).with('THEMEALDB_API_KEY').and_return(key)
    end

    it 'returns empty array when given empty ingredient list' do
      expect(described_class.filter_by_ingredients([])).to eq([])
    end

    it 'parses a successful filter response into simplified meal hashes' do
      json = { "meals" => [
        { "idMeal" => "1234", "strMeal" => "Test Meal", "strMealThumb" => "https://example.com/thumb.jpg" }
      ] }.to_json

      # create a response-like double
      fake_response = double('response', body: json)
      allow(fake_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)

      http_instance = instance_double(Net::HTTP)
      allow(Net::HTTP).to receive(:new).and_return(http_instance)
      allow(http_instance).to receive(:use_ssl=)
      allow(http_instance).to receive(:open_timeout=)
      allow(http_instance).to receive(:read_timeout=)
      allow(http_instance).to receive(:request).and_return(fake_response)

  result = described_class.filter_by_ingredients([ 'Chicken', 'Onion' ])

      expect(result).to be_an(Array)
      expect(result.size).to eq(1)
      expect(result.first[:id]).to eq('1234')
      expect(result.first[:name]).to eq('Test Meal')
      expect(result.first[:thumb]).to eq('https://example.com/thumb.jpg')
    end

    it 'returns empty array on non-successful HTTP response' do
      fake_response = double('error_response')
      allow(fake_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)

      http_instance = instance_double(Net::HTTP)
      allow(Net::HTTP).to receive(:new).and_return(http_instance)
      allow(http_instance).to receive(:use_ssl=)
      allow(http_instance).to receive(:open_timeout=)
      allow(http_instance).to receive(:read_timeout=)
      allow(http_instance).to receive(:request).and_return(fake_response)

  expect(described_class.filter_by_ingredients([ 'Salt' ])).to eq([])
    end
  end
end
