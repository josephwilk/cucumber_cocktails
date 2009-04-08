module Cucumber
  module Formatter
    class Inprogress < Progress
     
      FORMATS[:invalid_pass] = Proc.new{ |string| ::Term::ANSIColor.blue(string) }

      def initialize(step_mother, io, options)
        super(step_mother, io, options)
        @scenario_passed = true
        @passing_scenarios = []
      end

      def visit_feature_element(feature_element)
        @indent = 2
        super
        
        @passing_scenarios << feature_element if @scenario_passed
        @scenario_passed = true
        
        @io.puts
        @io.flush
      end

      def visit_step_name(keyword, step_match, status, source_indent, background)
        progress(status) unless status == :outline
      end

      def visit_table_cell_value(value, width, status)
        progress(status) if (status != :thead) && !@multiline_arg
      end

      def visit_tags(tags)
        @tags = tags
        tags.accept(self)
      end

      private
      
      def progress(status)
        @scenario_passed = false unless status == :passed
        super
      end

      def print_summary
        unless @passing_scenarios.empty?
          puts format_string("(::) Scenarios passing which should be failing or pending (::)", :invalid_pass)
          puts
          @passing_scenarios.each do |element|
            puts(format_string(element.backtrace_line, :invalid_pass))
          end
          puts
        end
        print_counts
      end
    end
  end
end
