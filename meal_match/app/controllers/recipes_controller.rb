class RecipesController < ApplicationController
  # GET /recipes/ingredients/:ingredient_id
  #
  # Given an ingredient list id, search for the recipes that the user
  # can cook using those ingredients.
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

    redirect_to ingredient_list_recipes_path(@ingredient_list)
  end
end
