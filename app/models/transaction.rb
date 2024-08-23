class Transaction < ApplicationRecord
  after_create :transfer_money, :create_transaction_validation, :create_transaction_books
  before_create :check_wallet

  def check_wallet
    if self.source_wallet_address.present?
      source_wallet = Wallet.find_by(wallet_address: self.source_wallet_address)
      unless source_wallet.present?
        raise "Source wallet not found."
      end
    end

    if self.target_wallet_address.present?
      target_wallet = Wallet.find_by(wallet_address: self.target_wallet_address)
      unless target_wallet.present?
        raise "Target wallet not found."
      end
    end
  end

  def transfer_money
    source_wallet = Wallet.find_by(wallet_address: self.source_wallet_address)

    if source_wallet.present?
      if (source_wallet.total_book-self.amount) < 0
        raise "Your balance is not enough."
      end
    end

  end

  def create_transaction_validation
    details = {
      source_wallet_address: self.source_wallet_address,
      target_wallet_address: self.target_wallet_address,
      amount: self.amount,
      created_at: self.created_at.to_i
    }
    hashed_details = Digest::SHA256.hexdigest(details.to_s)

    TransactionValidation.create!(
      transaction_id: self.id,
      hash_validation: hashed_details
    )
  end

  def create_transaction_books
    source_wallet = Wallet.find_by(wallet_address: self.source_wallet_address)
    target_wallet = Wallet.find_by(wallet_address: self.target_wallet_address)

    TransactionBook.create!(
      wallet_id: source_wallet.id,
      transaction_id: self.id,
      credit: self.amount
    ) if self.source_wallet_address.present?

    TransactionBook.create!(
      wallet_id: target_wallet.id,
      transaction_id: self.id,
      debit: self.amount
    ) if self.target_wallet_address.present?
  end
end
