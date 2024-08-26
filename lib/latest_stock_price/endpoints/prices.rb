module LatestStockPrice
  module Endpoints
    module Prices
      def self.fetch(client, symbols)
        client.get("/prices", { symbols: symbols })
      end
    end
  end
end
