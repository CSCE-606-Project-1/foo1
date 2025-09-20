require "httparty"

class RecipeSearchesController < ApplicationController
  before_action :set_recipe_search, only: %i[ show ]

  def new
    @recipe_search = RecipeSearch.new
  end

  # GET /recipe_searches/1
  def show
    # Split input on commas or whitespace
    ingredients = @recipe_search.ingredients.split(/[\s,]+/).reject(&:blank?)
    @meals_by_ingredient = {}

    ingredients.each do |ingredient|
      url = "https://www.themealdb.com/api/json/v1/1/filter.php?i=#{URI.encode_www_form_component(ingredient)}"
      response = HTTParty.get(url)

      if response.success?
        json = JSON.parse(response.body)
        @meals_by_ingredient[ingredient] = json["meals"] || []
      else
        @meals_by_ingredient[ingredient] = []
      end
    end
  end

  # POST /recipe_searches
  def create
    @recipe_search = RecipeSearch.new(recipe_search_params)

    if @recipe_search.save
      redirect_to @recipe_search
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

    def set_recipe_search
      @recipe_search = RecipeSearch.find(params[:id])
    end

    def recipe_search_params
      params.require(:recipe_search).permit(:ingredients)
    end
end
