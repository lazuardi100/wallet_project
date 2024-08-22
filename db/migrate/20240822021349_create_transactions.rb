class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.text :source_wallet_address, null: false
      t.text :target_wallet_address, null: false
      t.decimal :amount
      t.string :transaction_type, null: false
      t.timestamps
    end
  end
end
