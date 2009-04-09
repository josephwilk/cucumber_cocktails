module Cucumber
  module Formatter
    class InProgress < Progress
     
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

      private
      
      def progress(status)
        @scenario_passed = false unless status == :passed
        super
      end

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

        #When we run 0 scenarios cucumber will pass.
        #We cannot distinguish between a pass with scenarios and a pass with no scenarios.
        #So we overide the exit status with fail when there are no scenarios.
        if @feature_element_count == 0 
          at_exit do
            Kernel.exit(1)
          end
        end
          
      end
    end
  end
end
