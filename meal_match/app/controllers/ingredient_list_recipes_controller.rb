require "httparty"

class IngredientListRecipesController < ApplicationController
  before_action :require_login, only: %i[show]
  def show
    if @recipe_search.ingredient_list_id.present?
      @ingredient_list = @recipe_search.ingredient_list
      ingredients = @ingredient_list.ingredients.pluck(:title)
    else
      @ingredient_list = nil
      ingredients = @recipe_search.ingredients.to_s.split(/\s*,\s*/).reject(&:blank?)
    end

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
