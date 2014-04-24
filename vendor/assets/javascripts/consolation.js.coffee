#=require jquery
#=require zeroclipboard
unless $? || jQuery?
  throw "Consolation Error: jQuery is a dependency of consolation."

$(document).ready ->
  consolation_controller = new Consolation()

class Console
  is_in_range: (number,a,b) =>
    min = Math.min.apply(Math, [a,b])
    max = Math.max.apply(Math, [a,b])
    return number >= min && number <= max

  drag_start: (event) =>
    @copy_prompt.css({left: event.clientX, top: event.clientY})
    @copy_prompt.addClass('ready')
    @copy_prompt.animate({opacity:0.7}, 250)
    @line_drag_start = $(event.delegateTarget).data('line')
    @current_timeout_id = setTimeout(@show_extended_prompt, 3000)


  show_extended_prompt: () =>
    @copy_prompt.css({width: 'auto'})
    width = @copy_prompt.width()
    @copy_prompt.css({width: @starting_width})
    @copy_prompt.animate({width: width}, 500)

  drag_move: (event) =>
    @copy_prompt.css({left: event.clientX + 16, top: event.clientY - 16})

  drag_over: (event) =>
    if @line_drag_start > -1
      @line_drag_to = $(event.delegateTarget).data('line')
      @element.find('.consolation-line').each (index, elem) =>
        if @is_in_range($(elem).data('line'), @line_drag_start, @line_drag_to)
          $(elem).addClass('selected')
        else
          $(elem).removeClass('selected')

  drag_end: (event) =>
    @copy_prompt.fadeTo(1.0, 30)
    clearTimeout(@current_timeout_id)
    @copy_prompt.animate { top: @copy_prompt.offset().top - $(window).scrollTop() - 35, opacity: 0, width: @starting_width}, 500, =>
      @copy_prompt.removeClass('ready')
    @line_drag_to = $(event.delegateTarget).data('line')
    @element.find('.consolation-line').removeClass("selected")
    console.log("Selected #{Math.abs(@line_drag_start - @line_drag_to) + 1} lines from #{@line_drag_start} to #{@line_drag_to}")

    text_to_copy = ""
    @element.find('.consolation-line').each (index, elem) =>
        if @is_in_range($(elem).data('line'), @line_drag_start, @line_drag_to)
          text_to_copy += $(elem).text()
    console.log @clipboard.setText text_to_copy

  drag_cancel: (event) =>
    clearTimeout(@current_timeout_id)
    @copy_prompt.animate { top: @copy_prompt.offset().top - $(window).scrollTop() + 35, opacity: 0, width: @starting_width}, 250, =>
      @copy_prompt.removeClass('ready')

    @line_drag_start = -1
    @line_drag_end = -1
    @element.find('.consolation-line').removeClass("selected")

  bind_to_events: () =>
    @element.find('.consolation-line').mousedown(@drag_start)
    @element.find('.consolation-line').mouseup(@drag_end)
    @element.find('.consolation-line').mouseover(@drag_over)
    @element.find('.consolation-line').mousemove(@drag_move)
    $(document).mouseup(@drag_cancel)

  init: () ->
    @bind_to_events()

  constructor: (@element, @line_drag_start = -1, @line_drag_to = -1) ->
    @copy_prompt = $(@element.parent().find('.consolation-copy-prompt')[0])
    @current_timeout_id = 0
    @starting_width = @copy_prompt.width()
    @clipboard = new ZeroClipboard();

class Consolation

  constructor: () ->
    $('.consolation-console').each ->
      console = new Console($(this))
      console.init()
