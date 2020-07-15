class CreateCompanyPermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :account_companies_permissions, id: :uuid, default: -> { "uuid_generate_v1mc()" } do |t|
      t.references :company, type: :uuid, index: true, foreign_key: true, null: false
      t.references :permission, type: :uuid, index: true, foreign_key: true, null: false
    end
  end
end
