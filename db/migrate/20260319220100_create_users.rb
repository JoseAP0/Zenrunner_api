class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :role, null: false
      t.integer :token_version, null: false, default: 0

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :role
  end
end
