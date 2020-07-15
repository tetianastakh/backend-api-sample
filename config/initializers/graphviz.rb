module StateMachines
  class Machine
    class << self
      def draw(class_names, options = {})
        if class_names && class_names.split(',').empty?
          raise ArgumentError, 'At least one class must be specified'
        end

        files = options.delete(:file)
        files.split(',').each { |file| require file } if files

        class_names.split(',').each do |class_name|
          klass = class_name.constantize

          klass.state_machines.each_value do |machine|
            machine.draw(options)
          end
        end
      end
    end
  end
end
