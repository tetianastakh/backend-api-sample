module Account
  class UserPolicy < ApplicationPolicy
    def read_users?
      has_permissions?(:read_users, :write_users, :manage_users)
    end

    def write_users?
      has_permissions?(:write_users, :manage_users)
    end
  end
end
