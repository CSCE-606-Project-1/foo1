require "httparty"

class IngredientListRecipesController < ApplicationController
  before_action :require_login, only: %i[show]

  def show
    @ingredient_list = current_user.ingredient_lists.find(params[:id])
    ingredients = @ingredient_list.ingredients.pluck(:title)

    if ingredients.any?
      # Join ingredients with commas for a combined search
      query = ingredients.map { |i| i.strip.gsub(/\s+/, "_") }.join(",")
      url = "https://www.themealdb.com/api/json/v2/65232507/filter.php?i=#{URI.encode_www_form_component(query)}"

      response = HTTParty.get(url)
      @meals = response.success? ? JSON.parse(response.body)["meals"] || [] : []
    else
      @meals = []
    end
  end
end
