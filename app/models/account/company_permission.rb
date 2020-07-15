module Account
  class CompanyPermission < ApplicationRecord
    self.table_name = 'account_companies_permissions'

    # Extensions
    ############################################################################

    audited

    # Relations
    ############################################################################

    belongs_to :permission, class_name: Account::Permission.name, optional: true
    belongs_to :company, class_name: Account::company.name, optional: true

    # Validations
    ############################################################################

    validates_uniqueness_of :permission_id, scope: :company_id

    # Callbacks
    ############################################################################

    before_destroy :remove_from_roles

    # Instance Methods
    ############################################################################

    def remove_from_roles
      Account::RolePermission
        .joins(:role)
        .where(
          permission_id: permission.id,
          roles: { company_id: company.id }
        )
        .destroy_all
    rescue ActiveRecord::RecordNotDestroyed => e
      errors.add(:permission, e.message)
      throw :abort
    end
  end
end
