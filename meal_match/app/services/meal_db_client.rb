# frozen_string_literal: true
require "net/http"
require "uri"
require "json"

class MealDbClient
  # Returns [{ id:, name:, description: }, ...] filtered by substring match.
  def self.search_ingredients(query)
    q = query.to_s.strip
    return [] if q.empty?

    all = fetch_all_ingredients
    qd = q.downcase
    all.select { |ing| (ing[:name] || "").downcase.include?(qd) }[0, 25]
  end

  def self.fetch_all_ingredients
    # memoize once per process
    @ingredients_cache ||= begin
      base = ENV.fetch("THEMEALDB_API_BASE", "https://www.themealdb.com/api/json/v2").to_s.sub(%r{/\z}, "")
      key  = ENV.fetch("THEMEALDB_API_KEY")
      raise "THEMEALDB_API_KEY must be set" if key.nil? || key.empty?

      uri = URI.parse("#{base}/#{key}/list.php?i=list")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.open_timeout = 5
      http.read_timeout = 5

      req = Net::HTTP::Get.new(uri.request_uri)
      req["User-Agent"] = "MealMatch/1.0 (+Rails)"

      res = http.request(req)

      # If the HTTP call fails, return an empty array instead of nil
      if !res.is_a?(Net::HTTPSuccess)
        []
      else
        body  = JSON.parse(res.body) rescue {}
        items = body["meals"] || []  # note: TheMealDB returns ingredient list under "meals"

        items.map do |ing|
          {
            id:          (ing["idIngredient"] || ing["id"] || "").to_s,
            name:        ing["strIngredient"] || ing["name"] || "",
            description: ing["strDescription"] || ing["description"] || ""
          }
        end
      end
    end
  end
end
