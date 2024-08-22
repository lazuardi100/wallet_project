class User < ApplicationRecord
  has_secure_password
  has_one :wallet

  validates :email, presence: true, uniqueness: true

  def create_wallet
    Wallet.create!(
      walletable_type: self.class.name,
      walletable_id: self.id,
      wallet_address: SecureRandom.hex(32)
    )
  end

  def my_wallet
    wallet = Wallet.find_by(walletable_type: "User", walletable_id: self.id)
  end
end
