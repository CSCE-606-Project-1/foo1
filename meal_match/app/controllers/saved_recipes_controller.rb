class SavedRecipesController < ApplicationController
  before_action :require_login

  def index
    @saved_recipes = current_user.saved_recipes
  end

  def create
    recipe = current_user.saved_recipes.new(
      meal_id: params[:meal_id],
      name: params[:name],
      thumbnail: params[:thumbnail]
    )

    if recipe.save
      render json: { success: true, message: "Recipe saved!" }
    else
      render json: { success: false, message: recipe.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def destroy
    recipe = current_user.saved_recipes.find(params[:id])
    recipe.destroy
    redirect_to saved_recipes_path, notice: "Recipe removed."
  end
end
