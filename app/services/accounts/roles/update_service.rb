module Accounts
  module Roles
    class UpdateService < BaseService
      class << self
        def perform(user, id, params = {})
          role           = find(user, id)
          permission_ids = params.delete(:permission_ids)
          params         = params.merge(permission_ids: format_permission_ids(role, permission_ids))

          unless role.update(params)
            raise ::Exceptions::UnableToUpdate.new(record: role)
          end

          role.reload
        end

        private def format_permission_ids(role, ids)
          return [] if ids.blank?

          Account::CompanyPermission
            .where(company_id: role.company_id, permission_id: ids)
            .pluck(:permission_id)
        end
      end
    end
  end
end
