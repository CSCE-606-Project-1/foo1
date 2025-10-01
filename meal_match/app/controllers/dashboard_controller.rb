# Controller for showing dashboard against a user
class DashboardController < ApplicationController
  # Logged in user needed to display a dashboard (method to validate
  # defined in base class ApplicationController)
  before_action :require_login

  def show
    @current_user_ingredient_lists = current_user.ingredient_lists
  end
  # Render a dedicated Add Ingredients page. The modal markup and
  # progressive-enhancement JS were moved into the ingredient lists UI.
end
