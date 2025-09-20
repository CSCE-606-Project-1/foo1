# Controller for showing dashboard against a user
class DashboardController < ApplicationController
  # Logged in user needed to display a dashboard (method to validate
  # defined in base class ApplicationController)
  before_action :require_login

  def show
  end

  # GET /ingredient_search?q=term
  # Proxies a search to the FoodData Central (FDC) API and returns JSON results
  def ingredient_search
    Rails.logger.debug "ingredient_search called; params=#{params.to_unsafe_h.except(:controller, :action)}; format=#{request.format}"
    query = params[:q].to_s.strip
    return render json: [] if query.blank?

    api_key = ENV["FDC_API_KEY"]
    unless api_key.present?
      Rails.logger.warn "FDC_API_KEY not set"
      return render json: [], status: :service_unavailable
    end

    require "net/http"
    require "uri"
    require "json"

    uri = URI("https://api.nal.usda.gov/fdc/v1/foods/search")
    uri.query = URI.encode_www_form({ api_key: api_key, query: query, pageSize: 25 })

    begin
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        body = JSON.parse(res.body)
        # The FDC search returns 'foods' array; normalize to include fdcId and description
        foods = Array(body["foods"]).map do |f|
          {
            fdcId: f["fdcId"] || f["fdc_id"],
            description: f["description"] || f["lowercaseDescription"] || f["food_name"],
            brand_owner: f["brandOwner"] || f["brand_owner"]
          }
        end
        render json: foods
      else
        Rails.logger.error "FDC search failed: #{res.code} #{res.body}"
        render json: [], status: :bad_gateway
      end
    rescue => e
      Rails.logger.error "FDC search error: #{e.class} #{e.message}"
      render json: [], status: :bad_gateway
    end
  end
end
