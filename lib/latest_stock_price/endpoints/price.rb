module LatestStockPrice
  module Endpoints
    module Price
      def self.fetch(client, symbol)
        client.get("/equities", { Indicies: symbol })
      end
    end
  end
end
