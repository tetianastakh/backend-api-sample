class BaseInteractor
  include Interactor

  def validate_required_args!(required_args = [])
    missing_args = []

    required_args.each do |arg|
      missing_args.push(arg) unless context[arg]
    end

    yield missing_args if block_given?

    if missing_args.any?
      message = "Missing required argument(s): #{missing_args.join(', ')}"
      context.fail!(message: message)
    end
  end

  def return_context(context)
    @context = context
  end

  def report_rollback_failure(exception)
    Rails.logger.error("Failed to revert changes: #{exception.message}. Interactor: #{self.class.name}")
  end
end
