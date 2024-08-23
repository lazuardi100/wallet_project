class Wallet < ApplicationRecord
  before_save :check_balance
  before_update :check_balance

  def check_balance
    if self.total_book < 0
      raise "Your balance is not enough."
    end
  end

  def total_book
    debit_book = TransactionBook.where(wallet_id: self.id).sum(:debit)
    credit_book = TransactionBook.where(wallet_id: self.id).sum(:credit)
    debit_book - credit_book
  end
end
