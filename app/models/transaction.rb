class Transaction < ApplicationRecord
  after_create :create_transaction_validation

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
end
