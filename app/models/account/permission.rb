module Account
  class Permission < ApplicationRecord
    audited

    # Relationships
    ############################################################################

    has_many :company_permissions, dependent: :destroy, class_name: Account::CompanyPermission.name
    has_many :role_permissions, dependent: :destroy, class_name: Account::RolePermission.name
    has_many :roles, through: :role_permissions, class_name: Account::Role.name

    # Validations
    ############################################################################

    validates :name, :description, presence: true
  end
end
