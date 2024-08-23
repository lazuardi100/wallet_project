class Transaction < ApplicationRecord
  after_create :create_transaction_validation, :create_transaction_books

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
    source_wallet = Wallet.find_by(address: self.source_wallet_address)
    target_wallet = Wallet.find_by(address: self.target_wallet_address)

    TransactionBook.create!(
      wallet_id: source_wallet.id,
      transaction_id: self.id,
      debit: self.amount
    ) if self.source_wallet_address.present?

    TransactionBook.create!(
      wallet_id: target_wallet.id,
      transaction_id: self.id,
      credit: self.amount
    ) if self.target_wallet_address.present?
end
