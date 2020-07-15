class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: :uuid, default: -> { "uuid_generate_v1mc()" } do |t|
      t.string      :email,                         null: false
      t.string      :password_digest,               null: false
      t.string      :reset_password_token
      t.datetime    :reset_password_created_at
      t.string      :first_name
      t.string      :last_name
      t.string      :phone_number
      t.integer     :role,          default: 1,     null: false
      t.boolean     :confirmed,      default: false, null: false
      t.datetime    :confirmed_at
      t.string      :confirmation_token

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end