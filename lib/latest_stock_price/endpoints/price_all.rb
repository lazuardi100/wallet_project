module LatestStockPrice
  module Endpoints
    module PriceAll
      def self.fetch(client)
        client.get("/any")
      end
    end
  end
end
