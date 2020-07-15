module Accounts
  module Roles
    class CreateService
      class << self
        def perform(user, params = {})
          company_id    = company_id(user, params)
          permission_ids     = params.fetch(:permission_ids, []).uniq
          comp_permission_ids = Account::CompanyPermission
            .where(
              company_id: company_id,
              permission_id: permission_ids
            )
            .pluck(:permission_id).uniq

          if permission_ids.length != comp_permission_ids.length
            raise ::Exceptions::ArgumentError.new(
              message: 'Attempting to assign permission which does not belong to the company')
          end

          params = params.merge(permission_ids: org_permission_ids, company_id: company_id)
          role   = Account::Role.new(params)

          raise Exceptions::UnableToCreate.new(record: role) unless role.save

          role
        end

        private

        def company_id(user, params)
          ApplicationPolicy.new(user).manage_users? ? params[:company_id] : user.company.id
        end
      end
    end
  end
end
