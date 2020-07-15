module Exceptions
  class UnableToFetchActivityHistory < BaseException
    def message
      'There was a problem loading the activity history.'
    end
  end
end
