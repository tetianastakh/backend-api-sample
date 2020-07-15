module Accounts
  module Roles
    class BaseService < Accounts::BaseService
      class << self
        def item_class
          Account::Role
        end
      end
    end
  end
end
