#= require ansi_up

class ConsolationConsole

  ansi_replacement_regex: /\[([0-9]*)(;[0-9]*)?m/gi
  ansi_replacement_map: {
    "30" : "black",
    "31" : "red",
    "32" : "green",
    "33" : "yellow",
    "34" : "blue",
    "35" : "magenta",
    "36" : "cyan",
    "37" : "white",
    "39" : "bold"
  }

  sub_ansi_colors_in_string: (string) ->
    ansi_up.ansi_to_html(string);

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
          setTimeout(@poll_for_new_logs, 1000)
        ,
        error:    (response, status) =>
          console.log(response, status)
          @next_url = null
      })

      request.start()

  constructor: (@element) ->
    @element.innerHTML = @sub_ansi_colors_in_string(@element.innerHTML)
    if(@element.dataset.nextLogPath)
      @next_url = @element.dataset.nextLogPath
      @poll_for_new_logs()

class Consolation
  constructor: () ->
    consoles = document.querySelectorAll('.consolation-console')
    new ConsolationConsole(c) for c in consoles

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
  consolation_controller = new Consolation()

document.addEventListener "DOMContentLoaded", ->
  ready()

document.addEventListener "page:load", ->
  ready()


