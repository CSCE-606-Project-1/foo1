# Controller for showing dashboard against a user
class DashboardController < ApplicationController
  # Logged in user needed to display a dashboard (method to validate
  # defined in base class ApplicationController)
  before_action :require_login

  def show
  end

  # Render a dedicated Add Ingredients page. The modal markup and
  # progressive-enhancement JS are moved into a separate template so
  # it can be tested and visited directly at /add-ingredients.
  def add_ingredients
  end

  # AJAX endpoint used by the front-end ingredient search. Returns JSON.
  def ingredient_search
    q = params[:q].to_s.strip
    items = q.present? ? MealDbClient.search_ingredients(q) : []
    render json: { ingredients: items }
  rescue => e
    Rails.logger.warn("[ingredient_search] #{e.class}: #{e.message}")
    render json: { ingredients: [] }, status: :bad_gateway
  end
end
