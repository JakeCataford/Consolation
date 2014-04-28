module Consolation
  module Adapters
    class Fake
      def initialize contents
        @contents = contents
        @current_line = 0
      end

      def has_new_message?
        return true
      end

      def new_messages
        lines = Array.new
        lines.push @contents.lines.to_a[@current_line]
        @current_line += 1
        return lines
      end

      def end_of_data?
        return @current_line >= @contents.lines.to_a.count
      end

      def stop
        return true
      end
    end
  end
end
