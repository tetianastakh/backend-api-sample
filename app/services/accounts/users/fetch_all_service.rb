module Accounts
  module Users
    class FetchAllService
      class << self
        def perform(user, params = {})
          fetch_users(user, params)
        end

        def fetch_users(user, params)
          User.joins(:company)
              .where(companies: { id: company_id(user, params) } )
        end

        def company_id(user, params)
          ApplicationPolicy.new(user).manage_users? ? params[:company_id] : user.company.id
        end
      end
    end
  end
end
