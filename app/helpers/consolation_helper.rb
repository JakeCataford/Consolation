  module ConsolationHelper
    def console(loggable, options={})
      defaults = {
        no_auto_lines: false,
        height: 0
      }

      options = defaults.merge(options)
      next_poll_id = "data-next-log-url=#{loggable.tail_url}"
      rendered_text   = "<pre class='consolation-console'>" + loggable.log_chunks.map(&:content).join("\n") + "</pre>"
      raw rendered_text
    end
  end
