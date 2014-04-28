require 'pty'
module Consolation
  module Adapters
    class PTYAdapter
      def initialize command, options = {}
        defaults = {
          pwd: Dir.pwd
        }
        @buffer = ""
        @options = defaults.merge(options)
        @command = command
        start()
      end

      def start
        @thread = Thread.new do
          begin
            puts "running command in pty"
            PTY.spawn( @command ) do |stdin, stdout, pid|
              stdin.each do |line|
                @buffer.concat("#{line}\n")
                puts line
              end
            end
          rescue
          ensure
            stop()
          end
        end
      end

      def new_messages
        lines = @buffer.lines.to_a
        @buffer = ""
        return lines
      end

      def has_new_message?
        not @buffer.empty?
      end

      def end_of_data?
        not @thread.alive?
      end

      def stop
        @thread.kill
      end
    end
  end
end
