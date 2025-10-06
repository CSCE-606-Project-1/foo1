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
        format.html do
          clean_referrer = remove_fragment_from_url(request.referrer)
          redirect_to clean_referrer || root_path, notice: "Recipe saved!"
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            success: false,
            message: recipe.errors.full_messages.join(", ")
          }, status: :unprocessable_entity
        end
        format.html do
          clean_referrer = remove_fragment_from_url(request.referrer)
          redirect_to clean_referrer || root_path,
                      alert: recipe.errors.full_messages.join(", ")
        end
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

  private

  # Removes any URL fragment (e.g., "#rr-recipe-5") from a URL.
  #
  # @param url [String, nil] The URL to sanitize.
  # @return [String, nil] The cleaned URL without a fragment.
  def remove_fragment_from_url(url)
    return nil if url.blank?

    uri = URI.parse(url)
    uri.fragment = nil
    uri.to_s
  rescue URI::InvalidURIError
    nil
  end
end
