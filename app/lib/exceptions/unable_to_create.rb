module Exceptions
  class UnableToCreate < BaseException
    def message
      @message || 'There was a problem creating.'
    end
  end
end
