class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.references :walletable, polymorphic: true, null: false
      t.decimal :balance, precision: 15, scale: 2, default: 0.0, null: false

      t.timestamps
    end
  end
end
