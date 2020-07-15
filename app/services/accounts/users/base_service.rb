module Accounts
  module Users
    class BaseService
      class << self
        def find(current_user, id)
          item  = users_scope(current_user, id).find_by(id: id)

          raise ::Exceptions::RecordNotFound.new unless item

          item
        end

        private

        def users_scope(user, id)
          ApplicationPolicy.new(user).manage_users? ? ::User.all : user.company.users
        end
      end
    end
  end
end
