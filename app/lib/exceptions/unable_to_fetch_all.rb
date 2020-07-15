module Exceptions
  class UnableToFetchAll < BaseException
    def message
      'There was a problem fetching records.'
    end
  end
end
