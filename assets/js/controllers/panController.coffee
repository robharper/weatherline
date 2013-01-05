define ['$', '_', 'util/domevents'], ($, _, DomEvents) ->

  msPerPixel = 20000

  getTouch = (event) ->
    if event.originalEvent.touches?[0]?
      event.originalEvent.touches[0]
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

      @settings = 
        flickThreshold: 20000
        flickEndSpeed: 100
        flickUpdatePeriod: 1000/30
        slowPanSpeed: 20000   # ms/pixel
        fastPanSpeed: 200000  # ms/pixel

    startMove: (ev) =>
      @endMomentum()
      x = getTouch(ev).pageX
      @move = 
        x: x
        time: @model.time

    pan: (ev) =>
      if @move?
        x = getTouch(ev).pageX
        distance = x - @move.x

        # If two fingers, double the pan effect
        if ev.originalEvent.touches?.length > 1
          distance = distance * @settings.fastPanSpeed
        else
          distance = distance * @settings.slowPanSpeed

        @model.setTime( @move.time - distance )

        if @move.lastTime and ev.timeStamp != @move.lastTime
          @move.speed = (distance-@move.lastDistance) / (ev.timeStamp - @move.lastTime)
        
        @move.lastTime = ev.timeStamp
        @move.lastDistance = distance

    endMove: (ev) =>
      if ev.originalEvent.touches?.length > 0
        @startMove(ev)
        return

      if Math.abs(@move.speed) > @settings.flickThreshold
        console.log(@move.speed)
        @momentum = 
          speed: @move.speed
          handle: setInterval(@continueMomentum, @settings.flickUpdatePeriod)

      @move = null  

    continueMomentum: () =>
      @model.setTime( @model.time - @momentum.speed*@settings.flickUpdatePeriod )
      @momentum.speed *= 0.9
      @endMomentum() if Math.abs(@momentum.speed) < @settings.flickEndSpeed

    endMomentum: () ->
      clearInterval(@momentum.handle) if @momentum
      @momentum = null

    dispose: () ->
      @unbindEvents()


  _.extend(PanController::, DomEvents)

  PanController