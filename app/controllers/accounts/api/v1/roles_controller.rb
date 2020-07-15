module Accounts
  module Api
    module V1
      class RolesController < BaseController
        def index
          policy.enforce!(:read_roles?)

          roles      = Accounts::Roles::FetchAllService.perform(@current_user, params)
          aggregates = roles.map { |role| ::Accounts::Roles::Aggregate.new(role).show_permissions }

          render json: aggregates
        end

        def show
          role   = Accounts::Roles::FetchService.perform(@current_user, params[:id])
          policy = policy(role)

          policy.enforce!(:read_roles?, :access_role?)

          render json: ::Accounts::Roles::Aggregate.new(role).show_permissions
        end

        def create
          policy.enforce!(:write_roles?)

          role = Accounts::Roles::CreateService.perform(@current_user, role_params)

          render json: ::Accounts::Roles::Aggregate.new(role)
        end

        def update
          role   = fetch_role(params[:id])
          policy = policy(role)

          policy.enforce!(:write_roles?, :access_role?)

          role = Accounts::Roles::UpdateService.perform(@current_user, params[:id], role_params)

          render json: ::Accounts::Roles::Aggregate.new(role).show_permissions
        end

        def destroy
          role   = fetch_role(params[:id])
          policy = policy(role)

          policy.enforce!(:write_roles?, :access_role?)

          Accounts::Roles::DestroyService.perform(params[:id])

          head :no_content
        end

        private

        def policy(role = nil)
          Account::RolePolicy.new(@current_user, role)
        end

        def fetch_role(id)
          Account::Role.find(id)
        end

        def role_params
          params.require(:role).permit(
            :name,
            permission_ids: []
          )
        end
      end
    end
  end
end
