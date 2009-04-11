module Cucumber
  module Formatter
    class InProgress < Progress
      FAILURE_CODE = 1
      SUCCESS_CODE = 0
      
      FORMATS[:invalid_pass] = Proc.new{ |string| ::Term::ANSIColor.blue(string) }
      def initialize(step_mother, io, options)
        super(step_mother, io, options)
        @scenario_passed = true
        @passing_scenarios = []
        @feature_element_count = 0
      end

      def visit_feature_element(feature_element)
        super
        
        @passing_scenarios << feature_element if @scenario_passed
        @scenario_passed = true
        @feature_element_count += 1

        @io.flush
      end
      
      def visit_exception(exception, status)
        @scenario_passed = false
        super
      end
            
      private
      
      def print_summary
        unless @passing_scenarios.empty?
          @io.puts format_string("(::) Scenarios passing which should be failing or pending (::)", :invalid_pass)
          @io.puts
          @passing_scenarios.each do |element|
            @io.puts(format_string(element.backtrace_line, :invalid_pass))
          end
          @io.puts
        end
        print_counts

        if non_passing_steps_occured? || @feature_element_count == 0
          override_exit_code(SUCCESS_CODE)
        else
          override_exit_code(FAILURE_CODE)
        end
      end

      def non_passing_steps_occured?
        @step_mother.steps(:pending).any? ||
        @step_mother.steps(:undefined).any? ||
        @step_mother.steps(:failed).any?
      end

      def override_exit_code(status_code)
        at_exit do
          Kernel.exit(status_code)
        end
      end
      
    end
  end
end
