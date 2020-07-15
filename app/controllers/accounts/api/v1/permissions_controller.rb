module Accounts
  module Api
    module V1
      class PermissionsController < BaseController
        def index
          policy.enforce!(:read_permissions?)

          aggregates  = Account::Permission.all.map do |permission|
            ::Accounts::Permissions::Aggregate.new(permission)
          end

          render json: aggregates
        end

        private

        def policy
          Account::PermissionPolicy.new(@current_user)
        end
      end
    end
  end
end
