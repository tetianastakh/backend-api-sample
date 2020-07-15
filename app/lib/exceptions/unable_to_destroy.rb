module Exceptions
  class UnableToDestroy < BaseException
    def message
      @message || 'There was a problem destroying.'
    end
  end
end
