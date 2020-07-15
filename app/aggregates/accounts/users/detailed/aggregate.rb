module Accounts
  module Users
    module Detailed
      class Aggregate < ::AggregateBase
        def initialize(user)
          attributes = {}.tap do |attrs|
            attrs[:id]                 = user.id
            attrs[:first_name]         = user.first_name
            attrs[:last_name]          = user.last_name
            attrs[:phone_number]       = user.phone_number
            attrs[:email]              = user.email
            attrs[:role]               = user.role
          end

          super(attributes)
        end
      end
    end
  end
end
