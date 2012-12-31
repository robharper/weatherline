define ['$', '_', 'util/domevents'], ($, _, DomEvents) ->

  msPerPixel = 60000

  getTouch = (event) ->
    if event.originalEvent.targetTouches?[0]?
      {x: event.originalEvent.targetTouches[0].pageX, y: event.originalEvent.targetTouches[0].pageY}
    else
      {x: event.pageX, y: event.pageY}

  class PanController

    events:
      "touchstart": "startMove"
      "touchmove": "pan"
      "touchend": "endMove"

    constructor: (options) ->
      @$el = $(options.el)
      @model = options.model
      @bindEvents()

    startMove: (ev) =>
      @move = 
        x: getTouch(ev).x
        time: @model.time

    pan: (ev) =>
      if @move?
        distance = getTouch(ev).x - @move.x
        @model.setTime( @move.time - msPerPixel*distance )

        @move.lastDistance = distance

    endMove: (ev) =>
      # TODO Momentum flick  
      @move = null

    dispose: () ->
      @unbindEvents()


  _.extend(PanController::, DomEvents)

  PanController