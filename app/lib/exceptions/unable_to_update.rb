module Exceptions
  class UnableToUpdate < BaseException
    def message
      @message || 'There has been a problem updating.'
    end
  end
end
