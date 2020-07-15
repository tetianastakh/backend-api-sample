class AddDescriptionToPermissions < ActiveRecord::Migration[5.2]
  def change
    add_column :permissions, :description, :text, null: false
    
    add_index :permissions, :name, unique: true

    change_column_null(:permissions, :controller, true)
    change_column_null(:permissions, :action, true)
  end
end
