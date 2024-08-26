
module LatestStockPrice
  require_relative "latest_stock_price/version"
  require_relative "latest_stock_price/client"
  require_relative "latest_stock_price/endpoints/price"
  require_relative "latest_stock_price/endpoints/prices"
  require_relative "latest_stock_price/endpoints/price_all"
  class Error < StandardError; end
end
