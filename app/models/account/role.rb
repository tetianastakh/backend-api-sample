module Account
  class Role < ApplicationRecord
    audited

    DEFAULT_NAMES = [
      ADMIN = 'Admin'.freeze,
      REGULAR = 'Regular'.freeze
    ]

    # Relationships
    ############################################################################

    has_many   :role_permissions, class_name: Account::RolePermission.name, dependent: :destroy
    has_many   :permissions, through: :role_permissions, class_name: Account::Permission.name
    has_many   :users, class_name: User.name, dependent: :restrict_with_exception
    belongs_to :company, class_name: Account::Company.name

    # Validations
    ############################################################################

    validates :name, presence: true
  end
end
