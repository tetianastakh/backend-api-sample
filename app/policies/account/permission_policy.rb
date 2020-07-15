module Account
  class PermissionPolicy < ApplicationPolicy
    def read_permissions?
      has_permissions?(:read_permissions, :manage_users)
    end
  end
end
