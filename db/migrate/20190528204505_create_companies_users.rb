class CreateCompaniesUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :companies_users, id: :uuid, default: -> { "uuid_generate_v1mc()" } do |t|
      t.references :company, type: :uuid, index: true, foreign_key: true, null: false
      t.references :user, type: :uuid, index: true, foreign_key: true, null: false
    end
  end
end
