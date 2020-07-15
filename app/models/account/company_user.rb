module Account
  class CompanyUser < ApplicationRecord
    audited

    self.table_name = 'companies_users'

    belongs_to :company, class_name: ::Account::Copany.name
    belongs_to :user, class_name: ::User.name
  end
end
