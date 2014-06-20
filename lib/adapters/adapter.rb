module Consolation
  module Adapters
    class Base
      def has_new_lines?
        return false
      end

      def end_of_data?
        return true
      end

      def new_messages
        return ""
      end

      def stop
        return true
      end
    end
  end
end
