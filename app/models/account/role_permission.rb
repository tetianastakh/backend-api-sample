module Account
  class RolePermission < ApplicationRecord
    self.table_name = 'roles_permissions'

    # Extensions
    ############################################################################

    audited

    # Relationships
    ############################################################################

    belongs_to :role, class_name: Account::Role.name
    belongs_to :permission, class_name: Account::Permission.name

    # Validations
    ############################################################################
    validate :permission_is_enabled_for_company

    # Instance Methods
    ############################################################################

    private def permission_is_enabled_for_company
      unless role.company.permissions.exists?(id: permission.id)
        errors.add(:permission, "'#{permission.name}' has not been enabled for company")
      end
    end
  end
end
