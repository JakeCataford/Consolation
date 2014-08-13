class Console

  @sub_ansi_colors: () ->
  
  constructor: (element) ->
    console.log(element.innerHtml)


class Consolation
  constructor: () ->
    consoles = document.querySelector('.consolation-console') 
    new Console(console) for console in consoles

document.addEventListener "DOMContentLoaded", ->
  consolation_controller = new Consolation()

