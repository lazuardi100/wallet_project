class Team < ApplicationRecord
  has_one :wallet

  def create_wallet
    Wallet.create!(
      walletable_type: self.class.name,
      walletable_id: self.id,
      wallet_address: SecureRandom.hex(32)
    )
  end

  def my_wallet
    wallet = Wallet.find_by(walletable_type: self.class.name, walletable_id: self.id)
  end
end
