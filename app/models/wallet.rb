class Wallet < ApplicationRecord
  before_save :check_balance

  def check_balance
    if self.balance < 0
      raise "Your balance is not enough."
    end
  end
end
