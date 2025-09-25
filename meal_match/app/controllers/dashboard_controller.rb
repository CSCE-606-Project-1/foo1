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
end
