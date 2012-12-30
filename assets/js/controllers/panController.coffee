define ['$', '_', 'util/domevents'], ($, _, DomEvents) ->

  msPerPixel = 60000

  class PanController

    events:
      "mousedown": "startMove"
      "mousemove": "pan"
      "mouseup": "endMove"

    constructor: (options) ->
      @$el = $(options.el)
      @model = options.model
      @bindEvents()

    startMove: (ev) =>
      @move = 
        x: ev.pageX
        time: @model.time

    pan: (ev) =>
      if @move?
        distance = ev.pageX - @move.x
        @model.setTime( @move.time - msPerPixel*distance )

        @move.lastDistance = distance

    endMove: (ev) =>
      # TODO Momentum flick  
      @move = null

    dispose: () ->
      @unbindEvents()


  _.extend(PanController::, DomEvents)

  PanController