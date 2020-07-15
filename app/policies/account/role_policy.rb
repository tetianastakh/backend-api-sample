module Account
  class RolePolicy < ApplicationPolicy
    def read_roles?
      has_permissions?(:read_roles, :write_roles, :manage_users)
    end

    def write_roles?
      has_permissions?(:write_roles, :manage_users)
    end

    def access_role?
      manage_users? || record.company_id == @user.company.id
    end
  end
end
