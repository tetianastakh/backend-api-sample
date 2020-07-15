module Accounts
  module Roles
    class Aggregate < ::AggregateBase
      def initialize(role)
        attributes = {}.tap do |attrs|
          attrs[:id]     = role.id
          attrs[:name]   = role.name
          attrs[PRIVATE] = OpenStruct.new(role: role)
        end

        super(attributes)
      end

      def show_permissions
        permissions        = self.private.role.permissions
        self[:permissions] = populate_permissions(permissions)

        self
      end

      private

      def populate_permissions(permissions)
        return [] unless permissions

        permissions.map { |permission| Accounts::Permissions::Aggregate.new(permission) }
      end
    end
  end
end
