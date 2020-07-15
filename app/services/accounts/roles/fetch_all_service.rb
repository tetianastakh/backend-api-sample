module Accounts
  module Roles
    class FetchAllService
      class << self
        def perform(user, params = {})
          fetch_roles(user, params)
        end

        def fetch_roles(user, params)
          Account::Role.where(
            companies: { id: company_id(user, params) }
          )
        end

        def company_id(user, params)
          ApplicationPolicy.new(user).manage_users? ? params[:company_id] : user.company.id
        end
      end
    end
  end
end
