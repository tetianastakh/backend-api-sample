module Accounts
  module Permissions
    class Aggregate < ::AggregateBase
      def initialize(permission)
        attributes = {}.tap do |attrs|
          attrs[:id]   = permission.id
          attrs[:name] = permission.name
        end

        super(attributes)
      end
    end
  end
end
