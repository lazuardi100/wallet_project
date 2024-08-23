class TransactionsController < ApplicationController
  before_action :set_parent
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions or /transactions.json
  def index
    @wallet = @parent.my_wallet
    @transactions = Transaction
      .where("source_wallet_address = :wallet_address OR target_wallet_address = :wallet_address", wallet_address: @wallet.wallet_address)
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
    @wallet = @parent.my_wallet
  end

  def top_up
    @wallet = @parent.my_wallet
    @transaction = Transaction.new
  end

  def create_top_up
    @wallet = @parent.my_wallet
    begin
      ActiveRecord::Base.transaction do
        transaction = Transaction.new(
          source_wallet_address: nil,
          target_wallet_address: @wallet.wallet_address,
          amount: params[:amount]
        )
    
        
        if transaction.save
          @wallet.update!(balance: @wallet.balance + params[:amount].to_i)
          redirect_to polymorphic_path([@parent, :transactions]), notice: "Top up was successfully created."
        else
          render :top_up, status: :unprocessable_entity
        end
      end
    rescue => e
      render :top_up, status: :unprocessable_entity
    end
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    transaction_params = params.require(:transaction).permit(:recipient_address, :amount)
    @wallet = @parent.my_wallet

    target_wallet = Wallet.find_by(wallet_address: transaction_params[:recipient_address])
    if target_wallet.nil?
      redirect_to new_transaction_url, notice: "Recipient wallet not found."
      return
    end

    begin
      ActiveRecord::Base.transaction do
        transaction = Transaction.new(
          source_wallet_address: @wallet.wallet_address,
          target_wallet_address: transaction_params[:recipient_address],
          amount: transaction_params[:amount]
        )
    
        if transaction.save
          after_balance = @wallet.balance - transaction_params[:amount].to_i
          @wallet.update!(balance: after_balance)

          target_wallet.update!(balance: target_wallet.balance + transaction_params[:amount].to_i)
          redirect_to polymorphic_path([@parent, :transactions]), notice: "Transaction was successfully created."
        else
          redirect_to new_polymorphic_path([@parent, :transactions]), notice: "Transaction was not created."
        end
      end
    rescue => e
      redirect_to new_polymorphic_path([@parent, :transactions]), notice: "Transaction was not created."
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to transaction_url(@transaction), notice: "Transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy!

    respond_to do |format|
      format.html { redirect_to transactions_url, notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      # @transaction = Transaction.find(params[:id])
    end

    def set_parent
      if params[:team_id].present?
        @parent = Team.find(params[:team_id])
      elsif params[:user_id].present?
        @parent = current_user
      else
        @parent = current_user
      end
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.fetch(:transaction, {})
    end
end
