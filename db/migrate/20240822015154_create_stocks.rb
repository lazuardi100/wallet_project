class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :symbol, { null: false, unique: true }
      t.string :name, null: false
      
      t.timestamps
    end

    add_index :stocks, :symbol
  end
end
