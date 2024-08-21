class CreateSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :sessions do |t|
      # user_id is a foreign key that references the id column on the users table
      t.references :user, null: false, foreign_key: true
      t.text :session_token

      t.timestamps
    end
  end

  def down
    drop_table :sessions
  end
end
