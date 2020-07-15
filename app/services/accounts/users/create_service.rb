module Accounts
  module Users
    class CreateService
      class << self
        def perform(current_user, params = {})
          company = fetch_company(current_user, params.delete(:company_id))
          params       = params.merge(
            {}.tap do |p|
              p[:company] = company if company
            end
          )

          user = ::User.new(params)

          raise Exceptions::UnableToCreate.new(record: user) unless user.save

          return user
        end

        private

        def fetch_company(user, id)
          manage_users = ApplicationPolicy.new(user).manage_users?
          company    = manage_users ? Account::company.find_by(id: id) : user.company

          raise ::Exceptions::RecordNotFound.new(message: 'Unable to find company') unless company

          company
        end
      end
    end
  end
end
