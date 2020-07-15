module Account
  class Company < ApplicationRecord
    # Extensions
    ############################################################################

    include Imageable
    audited
    acts_as_paranoid

    # Relationships
    ############################################################################

    has_many :company_users, class_name: ::Account::CompanyUser.name
    has_many :users, through: :company_users, class_name: ::User.name
    has_many :roles, class_name: Account::Role.name
    has_many :company_permissions, foreign_key: :company_id, class_name: Account::CompanyPermission.name
    has_many :permissions, through: :company_permissions, class_name: Account::Permission.name
    has_many :roles, class_name: Account::Role.name

    accepts_nested_attributes_for :company_permissions, allow_destroy: true

    # Validations
    ############################################################################

    validates :name, presence: true
  end
end
