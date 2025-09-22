require "httparty"

class RecipeSearchesController < ApplicationController
  before_action :require_login, only: %i[new create show]
  before_action :set_recipe_search, only: %i[show]

  def new
    @recipe_search = RecipeSearch.new
    @ingredient_lists = current_user.ingredient_lists # safe now, current_user is guaranteed
  end

  def show
    ingredients =
      if @recipe_search.ingredient_list_id.present?
        @recipe_search.ingredient_list.ingredients.pluck(:title)
      else
        @recipe_search.ingredients.to_s.split(/[\s,]+/).reject(&:blank?)
      end

    @meals_by_ingredient = ingredients.index_with do |ingredient|
      url = "https://www.themealdb.com/api/json/v1/1/filter.php?i=#{URI.encode_www_form_component(ingredient)}"
      response = HTTParty.get(url)
      response.success? ? JSON.parse(response.body)["meals"] || [] : []
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
