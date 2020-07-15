module Accounts
  module Users
    class UpdateService < Accounts::Users::BaseService
      class << self
        def perform(user, id, params = {})
          params = params.to_h
          user   = find(user, id)
          params = format_role_and_company_params(user, params)

          raise ::Exceptions::UnableToUpdate.new(record: user) unless user.update(params)

          user.reload
        end

        private

        def format_role_and_company_params(user, params)
          return format_company_and_role_params(user, params) if params.key?(:company_id)
          return params
        end

        def format_company_and_role_params(user, params)
          company_id = params.delete(:company_id)
          role_id         = company_id.nil? ? nil : params.delete(:role_id)
          role            = params.delete(:role)

          params.tap do |attrs|
            attrs[:role_id] = role_id
            attrs[:role] = role if role
            attrs[:company_user_attributes] = {}.tap do |org_use_attrs|
              org_use_attrs[:id] = user.company_user.id
              org_use_attrs[:company_id] = company_id if company_id.present?
              org_use_attrs[:_destroy] = true if company_id.nil?
            end
          end
        end
      end
    end
  end
end
