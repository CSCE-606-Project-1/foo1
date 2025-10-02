
# !/usr/bin/env ruby
# frozen_string_literal: true

# Simple controller for recipe-specific endpoints (placeholder).
class RecipesController < ApplicationController
  # Controller responsible for recipe-related endpoints. Currently only a
  # placeholder search action is implemented — recipe matching logic is
  # intended to be added later.
  #
  # GET /recipes/ingredients/:ingredient_id
  #
  # Given an ingredient list id, search for the recipes that the user
  # can cook using those ingredients.
  #
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

    # TODO: Quan's code to search recipes given an ingredient list should
    # come here
    Rails.logger.debug "PLACEHOLDER for Quan's recipe search code !"
  end
end
