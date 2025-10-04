# Controller for managing user's saved recipes.
#
# @see SavedRecipe
class SavedRecipesController < ApplicationController
  # Ensures user is logged in before accessing any actions.
  #
  # @return [void]
  before_action :require_login

  # Lists all saved recipes for the current user.
  #
  # @return [void]
  def index
    @saved_recipes = current_user.saved_recipes
  end

  # Creates a new saved recipe for the current user.
  #
  # @return [void]
  def create
    recipe = current_user.saved_recipes.new(
      meal_id: params[:meal_id],
      name: params[:name],
      thumbnail: params[:thumbnail],
      category: params[:category],
      area: params[:area],
      description: params[:description]
    )

    if recipe.save
      respond_to do |format|
        format.json { render json: { success: true, message: "Recipe saved!" } }
        format.html { redirect_back fallback_location: request.referrer || root_path }
      end
    else
      respond_to do |format|
        format.json { render json: { success: false, message: recipe.errors.full_messages.join(", ") }, status: :unprocessable_entity }
        format.html { redirect_back fallback_location: request.referrer || root_path, alert: recipe.errors.full_messages.join(", ") }
      end
    end
  end

  # Deletes a saved recipe for the current user.
  #
  # @return [void]
  def destroy
    recipe = current_user.saved_recipes.find(params[:id])
    recipe.destroy
    redirect_to saved_recipes_path, notice: "Recipe removed."
  end
end
