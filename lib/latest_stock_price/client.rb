require 'net/http'
require 'json'

module LatestStockPrice
  class Client
    BASE_URL = "https://latest-stock-price.p.rapidapi.com"

    def initialize
      @api_key = Rails.application.credentials.rapid_api[:key]
    end

    def get(endpoint, params = {})
      uri = URI("#{BASE_URL}#{endpoint}")
      uri.query = URI.encode_www_form(params) if params.any?
      request = Net::HTTP::Get.new(uri)
      request["X-RapidAPI-Key"] = @api_key

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      JSON.parse(response.body)
    rescue StandardError => e
      raise LatestStockPrice::Error, "Error fetching data: #{e.message}"
    end
  end
end
