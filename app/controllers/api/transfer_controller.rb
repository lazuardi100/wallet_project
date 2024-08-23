class Api::TransferController < Api::BaseController
  def create
    begin
      ActiveRecord::Base.transaction do
        transaction = Transaction.new(transaction_params)
        if transaction.save
          render json: { transaction: transaction }
        else
          render json: { error: "Transaction could not be created." }
        end
      end
    rescue => e
      render json: { error: e.message }
    end
  end

  private
  def transaction_params
    params.require(:transaction).permit(
      :amount, 
      :source_wallet_address, 
      :target_wallet_address)
  end
end
