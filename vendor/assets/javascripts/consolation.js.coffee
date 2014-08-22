#= require ansi_up

window.Consolation = {}

class ConsolationConsole

  next_timeout_id: 0

  dispatch_log_update_event: (event_data) =>
    event = new CustomEvent("logs:update", { 'detail' : event_data })
    document.dispatchEvent(event)

  sub_ansi_colors_in_string: (string) ->
    ansi_up.ansi_to_html(string)

  poll_for_new_logs: =>
    if(@next_url)
      request = new AsyncRequestDelegate({
        method:   "GET",
        url:      @next_url,
        success:  (response, status) =>
          chunks = response.log_chunks
          content_to_append = chunks.map( (e) ->
            e.content
          ).join("")

          if(content_to_append)
            @element.innerHTML = @element.innerHTML + @sub_ansi_colors_in_string(content_to_append)

          @next_url = response.tail_path
          @dispatch_log_update_event(response.loggable)
          @next_timeout_id = setTimeout(@poll_for_new_logs, 1000)
        ,
        error:    (response, status) =>
          console.log(response, status)
          @next_url = null
      })

      request.start()

  stop: =>
    clearTimeout(@next_timeout_id)

  constructor: (@element) ->
    @element.innerHTML = @sub_ansi_colors_in_string(@element.innerHTML)
    if(@element.dataset.nextLogPath)
      @next_url = @element.dataset.nextLogPath
      @poll_for_new_logs()

class Consolation
  consoles: []
  constructor: () ->
    @consoles = document.querySelectorAll('.consolation-console')
    new ConsolationConsole(c) for c in @consoles

class AsyncRequestDelegate
  constructor: (@options) ->
    @xmlhttp = new XMLHttpRequest()
    @xmlhttp.open(@options.method, @options.url, true)
    @xmlhttp.onreadystatechange = =>
      if (@xmlhttp.readyState == 4)
        if(@xmlhttp.status == 200)
          @options.success(JSON.parse(@xmlhttp.responseText), @xmlhttp.status)
        else
          @options.error(JSON.parse(@xmlhttp.responseText), @xmlhttp.status)

  start: ->
    @xmlhttp.send()

ready = () ->
  if(window.Consolation.consolation_controller)
    c.stop() for c in window.Consolation.consolation_controller.consoles
    consolation_controller = null
  window.Consolation.consolation_controller = new Consolation()

document.addEventListener "DOMContentLoaded", ->
  ready()

document.addEventListener "page:load", ->
  ready()
