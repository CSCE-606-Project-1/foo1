
# !/usr/bin/env ruby
# frozen_string_literal: true

# Simple controller for recipe-specific endpoints (placeholder).
class RecipesController < ApplicationController
  # Controller responsible for recipe-related endpoints. Currently only a
  # placeholder search action is implemented — recipe matching logic is
  # intended to be added later.
  #
  # GET /recipes/ingredient_lists/:ingredient_list_id
  #
  # Search for recipes that can be cooked using the ingredients in the
  # specified IngredientList. The action supports HTML (renders
  # `recipes/search`) and JSON (returns `{ recipes: [...] }`).
  #
  # @param ingredient_list_id [Integer, String] the id of the IngredientList
  # @return [void]
  def search
    list_id = params[:ingredient_list_id]
    if list_id.nil?
      flash[:alert] = "End point received nil list id !"
      redirect_to dashboard_path
      return # redirect_to doesn't exit this method !
    end

    @ingredient_list = IngredientList.find_by(id: list_id)
    if @ingredient_list.nil?
      flash[:alert] = "Ingredient list with list id #{list_id} does not exist"
      redirect_to dashboard_path
      return # redirect_to doesn't exit this method !
    end

    # Build an array of ingredient names from the ingredient_list's ingredients
    ingredient_names = @ingredient_list.ingredients.map(&:title).map(&:to_s).reject(&:blank?)

    # Query TheMealDB filter endpoint using the user's selected ingredient list
    begin
      @recipes = MealDbClient.filter_by_ingredients(ingredient_names)
    rescue StandardError
      flash.now[:alert] = "Error fetching recipes"
      @recipes = []
    end

    respond_to do |format|
      format.html { render :search }
      format.json { render json: { recipes: @recipes } }
    end
  end

  # GET /recipes/ingredient_lists/intermediate
  #
  # (So that we are not dependent on client side javascript use
  # for dynamic URI generation based on dropdown selection) A helper
  # that takes ingredient list id as the query parameter and redirects
  # to the actual end point for the ingredient search which takes in
  # the ingredient list id as URI parameter.
  def search_intermediate
    ingredient_list_id = params[:ingredient_list_id]

    if ingredient_list_id.blank?
      flash[:alert] = "Please select an ingredient list !"
      redirect_to dashboard_path
      return
    end

    @ingredient_list = IngredientList.find_by(id: ingredient_list_id)

    if @ingredient_list.nil?
      flash[:alert] = "Ingredient list not found!"
      redirect_to dashboard_path
      return
    end
    redirect_to ingredient_list_recipe_path(id: ingredient_list_id)
  end
end
