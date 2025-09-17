# Controller for showing dashboard against a user
class DashboardController < ApplicationController
  # Logged in user needed to display a dashboard (method to validate
  # defined in base class ApplicationController)
  before_action :require_login

  def show
  end
end
