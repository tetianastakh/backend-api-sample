class CreateRolesPermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :roles_permissions, id: :uuid, default: -> { "uuid_generate_v1mc()" } do |t|
      t.references :role, type: :uuid, index: true, foreign_key: true, null: false
      t.references :permission, type: :uuid, index: true, foreign_key: true, null: false
    end
  end
end
