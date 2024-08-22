class AddWalletAddressInWallets < ActiveRecord::Migration[7.2]
  def change
    add_column :wallets, :wallet_address, :text, null: false
  end
end
