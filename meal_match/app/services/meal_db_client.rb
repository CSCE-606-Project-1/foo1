# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

# Lightweight client for fetching ingredient metadata from TheMealDB service.
#
# This class intentionally exposes only two high-level helpers used by the
# application: searching a cached list of ingredients and fetching the full
# list from the upstream API. Results are returned as an Array of Hashes with
# the keys :id, :name and :description.
class MealDbClient
  # Search cached ingredient metadata for a substring match on the ingredient
  # name (case-insensitive).
  #
  # @param query [String, #to_s] substring to search for. Blank or nil values
  #   return an empty array.
  # @return [Array<Hash{Symbol=>String}>] up to 25 ingredient hashes matching
  #   the query. Each hash contains :id, :name, and :description keys.
  def self.search_ingredients(query)
    q = query.to_s.strip
    return [] if q.empty?

    all = fetch_all_ingredients
    qd = q.downcase
    all.select { |ing| (ing[:name] || "").downcase.include?(qd) }[0, 25]
  end

  # Fetch and memoize the authoritative ingredient list from TheMealDB's
  # API. This method memoizes the result for the process lifetime so calls are
  # cheap after the first successful fetch.
  #
  # @return [Array<Hash{Symbol=>String}>] list of ingredient hashes with the
  #   keys :id, :name and :description. Returns an empty array if the HTTP
  #   request fails or the upstream response is malformed.
  # @raise [KeyError] if the environment variable THEMEALDB_API_KEY is not set
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
