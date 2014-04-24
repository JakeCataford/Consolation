module Consolation
  NON_BREAKING_SPACE = "&nbsp;"

  ANSI_COLOR_MAP = { 1 => :nothing,
                     2 => :nothing,
                     4 => :nothing,
                     5 => :nothing,
                     7 => :nothing,
                     30 => :black,
                     31 => :red,
                     32 => :green,
                     33 => :yellow,
                     34 => :blue,
                     35 => :magenta,
                     36 => :cyan,
                     37 => :white,
                     39 => :bold,
                     40 => :nothing,
                     41 => :nothing,
                     43 => :nothing,
                     44 => :nothing,
                     45 => :nothing,
                     46 => :nothing,
                     47 => :nothing,
  }

  URL_REGEX = /https?:\/\/[A-Za-z0-9\.\/]+/

  module Rails
    class Engine < ::Rails::Engine
      require 'zeroclipboard-rails'
    end
  end

  def console log_output, options={}
    #Make a console widget for a static log source.
    defaults = {
      no_auto_lines: false,
      truncate_to: 150,
      height: 0
    }

    options = defaults.merge(options)

    auto_line_numbers = true
    auto_line_numbers = false if log_output =~ /\A\d+\s/
    auto_line_counter = 1
    output = ""
    inside_console_tags output, options[:height] do
      put_copy_prompt output
      in_tag_with_class output, "tr", "line" do
        put_padding_line_number output
        put_padding_line output
      end

      total_lines = log_output.lines.count
      if total_lines > options[:truncate_to]
        log_output = log_output.split("\n").last(options[:truncate_to]).join("\n")
        auto_line_counter = total_lines - options[:truncate_to]
        put_expandable_line output, total_lines - options[:truncate_to]
      end

      log_output.each_line do |line|
        in_tag_with_class output, "tr", "line" do
          line_number = auto_line_counter if auto_line_numbers
          line_number ||= /\A\d+\s/.match(line).first
          put_line_number output, "#{line_number}"
          put_console_line output, escape_string_for_ansi(line), line_number
          auto_line_counter += 1 if auto_line_numbers
        end
      end

      in_tag_with_class output, "tr", "line" do
        put_padding_line_number output
        put_padding_line output
      end

    end
    return output.html_safe
  end

  private
  def inside_console_tags output, max_height
    if max_height > 0
      output << "<table class='consolation-console' style='max-height: #{max_height}px'>"
    else
      output << "<table class='consolation-console'>"
    end
    yield
    output << "</table>"
  end

  def in_tag_with_class output, tag, dom_class, data_attributes={}
    output << "<#{tag} class='#{dom_class}' "
    data_attributes.each do |key, value|
      output << "data-#{key}='#{value}' "
    end
    output << ">"
    yield
    output << "</#{tag}>"
  end

  def put_line_number output, number
    in_tag_with_class output, "td", "consolation-line-number" do
      output << number
    end
  end

  def put_console_line output, string, line_number
    in_tag_with_class output, "td", "consolation-line", line: line_number do
      output << string
    end
  end

  def put_padding_line_number output
    in_tag_with_class output, "td", "consolation-padding-line-number" do
      output << NON_BREAKING_SPACE
    end
  end

  def put_padding_line output
    in_tag_with_class output, "td", "consolation-padding-line" do
      output << NON_BREAKING_SPACE
    end
  end

  def put_expandable_line output, num_lines_omitted
    in_tag_with_class output, "td", "consolation-truncation-line-number" do
      output << "..."
    end
    in_tag_with_class output, "td", "consolation-truncation" do
      output << "Log too long, #{num_lines_omitted} lines omitted."
    end
  end

  def escape_string_for_ansi string
    ANSI_COLOR_MAP.each do |key, value|
      if value != :nothing
        string.gsub!(/\[#{key}m/,"<span class=\"consolation-ansi-#{value}\">")
        string.gsub!(/\[#{key};1m/,"<span class=\"consolation-ansi-#{value}\">")
      else
        string.gsub!(/\[#{key}m/,"<span>")
      end
    end
    string.gsub!(URL_REGEX) { |s| "<a href='#{s}'>#{s}</a>" }
    string.gsub!(/\[0m/,'</span>')
    return string
  end

  def put_copy_prompt output
    in_tag_with_class output, "div", "consolation-copy-prompt" do
      output << image_tag("consolation_copy_prompt_ic.png")
      in_tag_with_class output, "span", "consolation-copy-prompt-long" do
        output << "Stop dragging to copy to clipboard."
      end
    end
  end
end
