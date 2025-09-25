require "httparty"

class IngredientListRecipesController < ApplicationController
  before_action :require_login, only: %i[show]
  before_action :set_ingredient_list, only: %i[show]

  def show
    ingredients = @ingredient_list.ingredients.pluck(:title)

    if ingredients.any?
      query = ingredients.map { |i| i.strip.gsub(/\s+/, "_") }.join(",")
      api_key = ENV["MEALDB_API_KEY"]
      url = "https://www.themealdb.com/api/json/v2/#{api_key}/filter.php?i=#{URI.encode_www_form_component(query)}"

      response = HTTParty.get(url)
      meals = response.success? ? JSON.parse(response.body)["meals"] || [] : []

      @meals = meals.map do |meal|
        meal_id = meal["idMeal"]
        detail_url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{meal_id}"
        detail_res = HTTParty.get(detail_url)

        if detail_res.success?
          JSON.parse(detail_res.body)["meals"].first
        else
          meal
        end
      end.compact
    else
      @meals = []
    end
  end

  private

  def set_ingredient_list
    @ingredient_list = current_user.ingredient_lists.find(params[:id])
  end
end
