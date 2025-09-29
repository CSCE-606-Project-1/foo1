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
  # Normalize the query to singular form so tests that stub the
  # MealDbClient with a singular term (e.g. "tomato") still match
  # when the UI sends a plural (e.g. "tomatos"). Uses
  # ActiveSupport::Inflector#singularize which is available in Rails.
  normalized_q = q.present? ? q.singularize : q
  items = normalized_q.present? ? MealDbClient.search_ingredients(normalized_q) : []
    render json: { ingredients: items }
  rescue => e
    Rails.logger.warn("[ingredient_search] #{e.class}: #{e.message}")
    render json: { ingredients: [] }, status: :bad_gateway
  end
end
