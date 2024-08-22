class AddWalletAddressInWallets < ActiveRecord::Migration[7.2]
  def change
    add_column :wallets, :wallet_address, :text, null: false, default: SecureRandom.hex(32)
  end

  def down
    remove_column :wallets, :wallet_address
  end
end
