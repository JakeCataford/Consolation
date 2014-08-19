  module ConsolationHelper
    def console(loggable, options={})
      defaults = {
        no_auto_lines: false,
        height: 0
      }

      options = defaults.merge(options)
      next_poll_id = ""
      next_poll_id = "data-next-log-url=#{loggable.next_log_url}" unless loggable.next_log_id.nil?
      rendered_text   = "<pre class='consolation-console'>" + log_output.content + "</pre>"
      raw rendered_text
    end
  end
