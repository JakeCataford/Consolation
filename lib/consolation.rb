require 'erb'
require 'active_support'
require 'active_support/core_ext/string/output_safety'

module Consolation
  module Rails
    class Engine < ::Rails::Engine
    end
  end

  def console(log_output, options={})
    defaults = {
      no_auto_lines: false,
      height: 0
    }

    options = defaults.merge(options)
    template_path   = File.expand_path("../views/console.html.erb", __FILE__)
    template_string = File.read(template_path)
    rendered_text   = "<pre class='consolation'>" + log_output + "</pre>"
    rendered_text.html_safe
  end
end
