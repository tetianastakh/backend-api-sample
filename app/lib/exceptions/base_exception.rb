module Exceptions
  class BaseException < StandardError
    def initialize(message: nil, record: nil)
      @record = record
      @errors = record.try(:errors).try(:to_hash)
      @message = message
      super(message)
    end

    attr_reader :errors, :record
  end
end
