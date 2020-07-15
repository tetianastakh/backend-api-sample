module Exceptions
  class UnableToFetch < BaseException
    def message
      @message || 'There was a problem fetching the record'
    end
  end
end
