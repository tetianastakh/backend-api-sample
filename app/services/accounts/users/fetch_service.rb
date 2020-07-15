module Accounts
  module Users
    class FetchService < Accounts::Users::BaseService
      class << self
        def perform(user, id)
          find(user, id)
        end
      end
    end
  end
end
