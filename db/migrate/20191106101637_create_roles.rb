class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles, id: :uuid, default: -> { "uuid_generate_v1mc()" } do |t|
      t.string :name, null: false
      t.references :company, type: :uuid, index: true, foreign_key: true, null: false

      t.timestamps
    end
  end
end
