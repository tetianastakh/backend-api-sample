class IndexAccountCompanyPermissionByCompanyIdAndPermissionId < ActiveRecord::Migration[5.2]
  def change
    add_index :account_companies_permissions,
      [:company_id, :permission_id],
      unique: true,
      name: 'aop_ci_pi_idx'
  end
end
