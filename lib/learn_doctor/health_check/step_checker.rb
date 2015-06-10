module LearnDoctor
  class HealthCheck
    class StepChecker
      attr_reader   :step, :title
      attr_accessor :file, :result

      def initialize(step)
        @step = step
        @title = step[:title]
      end

      def execute
        set_file
        run_check_for_step
        print_result
        unlink_file!

        self
      end

      private

      def set_file
        self.file = LearnDoctor::HealthCheck::File.new(step, :check).file
      end

      def run_check_for_step
        print "Checking #{title}..."
        self.result = Open3.popen3('bash', file.path)[1].read.strip.to_i
      end

      def print_result
        if result == 1
          puts "ok"
        else
          puts "ok".red
        end
      end

      def unlink_file!
        file.unlink!
      end
    end
  end
end