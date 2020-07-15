module Accounts
  module Users
    class DestroyService < Accounts::Users::BaseService
      class << self
        def perform(user, id)
          user = find(user, id)
          user.delete
        end
      end
    end
  end
end
