class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, index: { unique: true }

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
