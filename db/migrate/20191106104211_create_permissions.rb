class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions, id: :uuid, default: -> { "uuid_generate_v1mc()" } do |t|
      t.string :name, null: false
      t.string :controller, null: false
      t.string :action, null:false

      t.timestamps
    end
  end
end
