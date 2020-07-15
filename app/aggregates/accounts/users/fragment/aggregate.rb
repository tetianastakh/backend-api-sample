module Accounts
  module Users
    module Fragment
      class Aggregate < ::AggregateBase
        def initialize(user)
          attributes = {}.tap do |attrs|
            attrs[:id]           = user.id
            attrs[:email]        = user.email
          end

          super(attributes)
        end
      end
    end
  end
end
