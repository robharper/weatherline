define ['$', '_', 'util/domevents'], ($, _, DomEvents) ->

  msPerPixel = 20000

  getTouch = (event) ->
    if event.originalEvent.targetTouches?[0]?
      event.originalEvent.targetTouches[0]
    else
      event

  class PanController

    events:
      "touchstart": "startMove"
      "touchmove": "pan"
      "touchend": "endMove"

    constructor: (options) ->
      @$el = $(options.el)
      @model = options.model
      @bindEvents()
      @flickThreshold = 0.1

    startMove: (ev) =>
      return if @move?

      @endMomentum()
      x = getTouch(ev).pageX
      @move = 
        x: x
        time: @model.time
        history: [{x:x, time:ev.timeStamp}]

    pan: (ev) =>
      if @move?
        x = getTouch(ev).pageX
        distance = x - @move.x

        # If two fingers, double the pan effect
        if ev.originalEvent.touches?.length > 1
          distance *= 2

        @model.setTime( @move.time - msPerPixel*distance )

        if @move.lastTime and ev.timeStamp != @move.lastTime
          @move.speed = (distance-@move.lastDistance) / (ev.timeStamp - @move.lastTime)
        
        @move.lastTime = ev.timeStamp
        @move.lastDistance = distance

    endMove: (ev) =>
      return if ev.originalEvent.touches?.length > 0
      if Math.abs(@move.speed) > @flickThreshold
        @momentum = 
          speed: @move.speed
          handle: setInterval(@continueMomentum, 1000/30)

      @move = null  

    continueMomentum: () =>
      @model.setTime( @model.time - msPerPixel*@momentum.speed*1000/30 )
      @momentum.speed *= 0.9
      @endMomentum() if Math.abs(@momentum.speed) < 0.1

    endMomentum: () ->
      clearInterval(@momentum.handle) if @momentum
      @momentum = null

    dispose: () ->
      @unbindEvents()


  _.extend(PanController::, DomEvents)

  PanController