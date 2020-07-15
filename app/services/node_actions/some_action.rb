module Workflow
  module NodeActions
    class SomeAction < ::BaseInteractor
      REQUIRED_ARGS = %w(some_arg)

      def call
        validate_required_args!(REQUIRED_ARGS)

        # Some actions here

        return context
      rescue ActiveRecord::RecordNotFound, ::Exceptions::BaseException => e
        context.fail!(message: e.message, exception: e)
      end
    end
  end
end