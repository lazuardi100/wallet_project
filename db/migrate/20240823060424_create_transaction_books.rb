class CreateTransactionBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :transaction_books do |t|
      t.references :wallet, null: false, foreign_key: true
      t.references :transaction, null: false, foreign_key: true
      t.decimal :debit
      t.decimal :credit
      t.timestamps
    end
  end

  def down
    drop_table :transaction_books
  end
end
