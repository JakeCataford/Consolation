#= require ansi_stream

class Console

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
    stream = new AnsiStream()
    stream.process(string)

  constructor: (element) ->
    element.html = @sub_ansi_colors_in_string(element.innerHTML)


class Consolation
  constructor: () ->
    consoles = document.querySelectorAll('.consolation-console')
    new Console(console) for console in consoles

document.addEventListener "DOMContentLoaded", ->
  consolation_controller = new Consolation()

