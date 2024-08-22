class CreateTransactionValidations < ActiveRecord::Migration[7.2]
  def change
    create_table :transaction_validations do |t|
      t.references :transaction, null: false, foreign_key: true
      t.text :hash_validation
      t.timestamps
    end
  end

  def down
    drop_table :transaction_validations
  end
end
