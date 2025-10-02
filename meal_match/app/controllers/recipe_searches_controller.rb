require "httparty"

class RecipeSearchesController < ApplicationController
  before_action :require_login, only: %i[new create show]
  before_action :set_recipe_search, only: %i[show]

  def new
    @recipe_search = RecipeSearch.new
    @ingredient_lists = current_user.ingredient_lists
  end

  def show
    if @recipe_search.ingredient_list_id.present?
      @ingredient_list = @recipe_search.ingredient_list
      ingredients = @ingredient_list.ingredients.pluck(:title)
    else
      @ingredient_list = nil
      ingredients = @recipe_search.ingredients.to_s.split(/\s*,\s*/).reject(&:blank?)
    end

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
          meal # fallback: return minimal data
        end
      end.compact
    else
      @meals = []
    end
  end

  def create
    @recipe_search = RecipeSearch.new(recipe_search_params)

    if @recipe_search.save
      redirect_to @recipe_search
    else
      @ingredient_lists = current_user.ingredient_lists
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_recipe_search
    @recipe_search = RecipeSearch.find(params[:id])
  end

  def recipe_search_params
    params.require(:recipe_search).permit(:ingredients, :ingredient_list_id)
  end
end
