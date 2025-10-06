# Controller for managing user's saved recipes.
#
# @see SavedRecipe
class SavedRecipesController < ApplicationController
  before_action :require_login

  # Lists all saved recipes for the current user.
  def index
    @saved_recipes = current_user.saved_recipes
  end

  # Creates a new saved recipe for the current user.
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
        format.json { head :ok } # respond with no message
        format.html do
          clean_referrer = remove_fragment_from_url(request.referrer)
          redirect_to clean_referrer || root_path
        end
      end
    else
      Rails.logger.error("Failed to save recipe: #{recipe.errors.full_messages.join(', ')}") if recipe.errors.any?
      respond_to do |format|
        format.json { head :unprocessable_entity }
        format.html do
          clean_referrer = remove_fragment_from_url(request.referrer)
          redirect_to clean_referrer || root_path
        end
      end
    end
  end

  # Deletes a saved recipe for the current user.
  def destroy
    recipe = current_user.saved_recipes.find(params[:id])
    recipe.destroy
    redirect_to saved_recipes_path
  end

  private

  def remove_fragment_from_url(url)
    return nil if url.blank?

    uri = URI.parse(url)
    uri.fragment = nil
    uri.to_s
  rescue URI::InvalidURIError
    nil
  end
end
