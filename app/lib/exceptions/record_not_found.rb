module Exceptions
  class RecordNotFound < BaseException
    def message
      @message || 'Record is not found.'
    end
  end
end
