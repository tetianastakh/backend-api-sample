module Workflow
  module Graphs
    class Base
      attr_accessor :state, :events

      # Signals
      ##########################

      CONTINUE = :continue
      YES      = :yes
      NO       = :no
      WAIT     = :wait

      # Call statuses
      ##########################

      NODE_FAILED = :node_failed
      NODE_OK     = :node_ok

      # Default States
      ##########################

      IDLE = :initial

      def initialize(opts = {})
        @enable_rollback = opts[:rollback] || false
        @events          = []
      end

      def rollback?
        @enable_rollback
      end

      # Refine this method with the class name of your node action
      # Must implement call and rollback methods
      def node_action
        nil
      end

      def can_handle_signal?(signal)
        self.state_events.include?(signal.to_sym)
      end

      # Redefine this method to mutate the context entering a node
      def prepare_context(workflow_context)
        return workflow_context
      end

      # Redefine this method within a state for custom behaviour
      def call(workflow_context, signal = CONTINUE)
        disable_auto_rollback(workflow_context)

        workflow_context = prepare_context(workflow_context)
        workflow_context = node_action.call(workflow_context) if node_action

        respond_with(workflow_context, signal)
      rescue StandardError => e
        workflow_context.fail!(message: e.message, exception: e) rescue Interactor::Failure
        respond_with(workflow_context, nil)
      end

      # Redefine this method within a state for custom behaviour
      def rollback(workflow_context)
        node_action && node_action.new(workflow_context).rollback
      end

      def respond_with(workflow_context, signal)
        return NODE_OK, signal, workflow_context if workflow_context.success?
        return NODE_FAILED, nil, workflow_context
      end

      private

      def disable_auto_rollback(workflow_context)
        # Disable called tracking to prevent automatic rollbacks
        workflow_context.instance_variable_set(:@called, [])
      end
    end
  end
end
