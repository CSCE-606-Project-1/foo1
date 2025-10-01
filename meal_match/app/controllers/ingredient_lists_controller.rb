class IngredientListsController < ApplicationController
  before_action :require_login

  # Show the current user's ingredient list UI. The page contains the
  # add-ingredients modal and search UI (copied from the dashboard add_ingredients
  # template) so users can manage their lists on a dedicated route.
  def show
  end
end
