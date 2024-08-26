class Api::RapidApiController < Api::BaseController
  before_action :init_client
  def price_all
    price_all = LatestStockPrice::Endpoints::PriceAll.fetch(@client)

    render json: price_all
  end

  def price
    indices = params[:indices]
    indices = indices.split(",")
    
    if indices.size > 1
      render json: {
        message: "Give one indices only"
      }
    else
      price = LatestStockPrice::Endpoints::Price.fetch(@client, indices)
      render json: price
    end
  end

  def prices
    indices = params[:indices]
    arr_indices = indices.dup.split(",")
    
    if arr_indices.size <= 1
      render json: {
        message: "Give more than one indices"
      }
    else
      price = LatestStockPrice::Endpoints::Price.fetch(@client, indices)
      render json: price
    end
  end

  private
  def init_client
    @client = LatestStockPrice::Client.new
  end
end
