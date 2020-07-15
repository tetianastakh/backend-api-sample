module Accounts
  module Roles
    class FetchService < BaseService
      class << self
        def perform(user, id)
          find(user, id)
        end
      end
    end
  end
end
