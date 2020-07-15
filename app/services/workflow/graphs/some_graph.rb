module Workflow
  module Graphs
    class SomeGraph < Workflow::Graphs::Base
      def initialize
        super(rollback: true)
      end

      state_machine :state, initial: IDLE do
        state IDLE do
          transition to: :new_state, on: CONTINUE
        end

        state :new_state do
          transition to: :next_state, on: YES
          transition to: :complete, on: NO

          def node_action
            ::Workflow::NodeActions::SomeAction # rake state_machines:draw CLASS=Workflow::Graphs::SomeGraph
          end

          def call(workflow_context)
            signal = (5 > 3) ? YES : NO

            respond_with(workflow_context, signal)
          end
        end

        state :next_state do
          transition to: :complete, on: CONTINUE

          def call(workflow_context)
            # some additional workflow_context assignment here
            super(workflow_context)
          end
        end

        state :complete do
          def call(workflow_context)
            super(workflow_context, WAIT)
          end
        end
      end
    end
  end
end
