module Accounts
  class SomeSystemEventInteractor < BaseInteractor
    REQUIRED_ARGS = %w(args).freeze
    ERROR         = 'Event failed'.freeze

    def call
      validate_required_args!(REQUIRED_ARGS)

      event_args = context.args.with_indifferent_access

      # Some action with event

      logger.info("Successfully sent Event.")
    rescue JSON::ParserError,
      Nokogiri::XML::SyntaxError,
      RestClient::RequestTimeout,
      RestClient::Exception => e
      context.fail!(exception: e)
    end

    def rollback
      Rails.logger.error("Unable to rollback #{self.class.name}")
    end

    private

    def logger
      @logger ||= Logger.new("#{Rails.root}/log/some_system_events.log")
    end
  end
end
