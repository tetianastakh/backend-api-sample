module Accounts
  module Api
    module V1
      class UsersController < BaseController
        def index
          policy.enforce!(:read_users?)

          users      = Accounts::Users::FetchAllService.perform(@current_user, params)
          aggregates = users.map do |user|
            ::Accounts::Users::Fragment::Aggregate.new(user)
          end

          render json: aggregates
        end

        def show
          user   = Accounts::Users::FetchService.perform(@current_user, params[:id])
          policy = policy(user)

          policy.enforce!(:read_users?, :access_user?)

          render json: ::Accounts::Users::Detailed::Aggregate.new(user)
        end

        def create
          policy.enforce!(:write_users?)

          user = Accounts::Users::CreateService.perform(@current_user, user_params)

          render json: ::Accounts::Users::Detailed::Aggregate.new(user)
        end

        def update
          user   = fetch_user(params[:id])
          policy = policy(user)

          policy.enforce!(:write_users?, :access_user?)

          user = Accounts::Users::UpdateService.perform(@current_user, params[:id], user_params)

          render json: ::Accounts::Users::Detailed::Aggregate.new(user)
        end

        def destroy
          user   = fetch_user(params[:id])
          policy = policy(user)

          policy.enforce!(:write_users?, :access_user?)

          Accounts::Users::DestroyService.perform(@current_user, params[:id])

          head :no_content
        end

        private

        def policy(user = nil)
          Account::UserPolicy.new(@current_user, user)
        end

        def fetch_user(id)
          User.find(id)
        end

        def user_params
          params.require(:user)
            .permit(
              :email,
              :password,
              :first_name,
              :last_name,
              :phone_number,
              :role,
              :role_id
            )
        end
      end
    end
  end
end
