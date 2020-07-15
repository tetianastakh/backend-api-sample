module Exceptions
  class ArgumentError < BaseException
    def message
      @message || 'Invalid argument(s)'
    end
  end
end
