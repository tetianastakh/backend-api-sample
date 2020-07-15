module Exceptions
  class BadPermission < BaseException
    def message
      @message || 'You do not have sufficient permission(s).'
    end
  end
end
