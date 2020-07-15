module Exceptions
  class UnableToScope < BaseException
    def message
      'There was a problem scoping'
    end
  end
end
