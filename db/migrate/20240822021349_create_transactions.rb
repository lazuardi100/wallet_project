class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.text :source_wallet_address, null: true
      t.text :target_wallet_address, null: true
      t.decimal :amount
      t.timestamps
    end
  end

  def down
    drop_table :transactions
  end
end
