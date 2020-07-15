module Workflow
  class Manager
    OK     = Workflow::Graphs::Base::NODE_OK
    FAILED = Workflow::Graphs::Base::NODE_FAILED
    WAIT   = Workflow::Graphs::Base::WAIT

    def initialize(graph, process, args = {})
      @process = process
      @graph   = graph
      @args    = args
    end

    def call(signal = nil)
      next_signal = get_signal(signal)
      call_status = nil
      context     = Interactor::Context.build(@args)

      loop do
        if @graph.can_handle_signal?(next_signal.to_sym)
          call_status, signal, context = execute_signal(next_signal, context)
        else
          call_status = FAILED
          fail_context(context, "Invalid signal: #{next_signal}")
        end

        break if call_status != OK || signal == WAIT
        next_signal = signal
      end

      if call_status == FAILED
        message = generate_error_message(next_signal, context)
        Rails.logger.error(message)
        rollback(context) if @graph.rollback?
      end

      return context
    end

    def rollback(context)
      visited_states = @process.visited.reverse.dup

      visited_states.each do |visited_state|
        @graph.state = visited_state

        @graph.rollback(context)

        @process.state = visited_state if visited_states.first != visited_state
      end

      return context
    end

    private

    def get_signal(signal)
      @graph.state = @process.state if @process.state

      return signal || @graph.state_events.first
    end

    def execute_signal(signal, context)
      @graph.events.push(signal)

      @graph.send(signal)

      call_status, next_signal, context = @graph.call(context.dup)

      @process.state = @graph.state if call_status == OK

      [call_status, next_signal, context]
    end

    def fail_context(context, message)
      context.fail!(message: message) rescue Interactor::Failure
    end

    def generate_error_message(signal, workflow_context)
      return "WorkflowManager #{@graph.class.name} Failed. " \
        "Signal: '#{signal}', " \
        "Process state: '#{@process.state}', " \
        "Graph state: '#{@graph.state}', " \
        "Error => #{workflow_context.message}"
    end
  end
end
