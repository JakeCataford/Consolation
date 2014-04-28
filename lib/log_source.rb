module Consolation
  module LogSource
  include ActionController::Live
  include Consolation
  def listen adapter
    response.headers['Content-Type'] = 'text/event-stream'
    begin
      has_connection = true
      while has_connection do
        if adapter.has_new_message?
          send_data adapter.new_messages
        end

        if adapter.end_of_data?
          send_eof
          has_connection = false
        end

        sleep(1)
      end
    rescue IOError
    ensure
      response.stream.close
      adapter.stop
    end
  end

  def send_eof
    response.stream.write("data: EOF\n")
    response.stream.write("data: \n\n")
  end

  def send_data data
    data.map do |message|
      new_line = to_console_line_html message
      response.stream.write("data: #{new_line}\n")
    end
    response.stream.write("data: \n\n")
  end
  end
end
