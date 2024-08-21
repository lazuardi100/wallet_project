class AddPasswordOnUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :password_digest, :string
  end

  def down
    remove_column :users, :password_digest
  end
end
