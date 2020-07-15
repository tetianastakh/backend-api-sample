module Accounts
  module Roles
    class DestroyService < BaseService
      class << self
        def perform(id)
          role = Account::Role.find(id)
          raise ::Exceptions::RecordNotFound unless role

          raise Exceptions::UnableToDestroy.new(record: role) unless role.destroy
        rescue StandardError
          raise
        end
      end
    end
  end
end
