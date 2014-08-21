module ConsolationHelper
  def console(loggable, options={})
    defaults = {
      no_auto_lines: false,
      height: 0
    }

    options         = defaults.merge(options)
    next_poll_id    = "data-next-log-path=#{loggable.tail_path}"
    rendered_text   = "<pre class='consolation-console' #{next_poll_id}>" + loggable.logs + "</pre>"
    raw rendered_text
  end
end
