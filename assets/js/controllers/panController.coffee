define ['$', '_', 'util/domevents'], ($, _, DomEvents) ->

  msPerPixel = 20000

  getTouch = (event) ->
    if event.originalEvent.touches?[0]?
      event.originalEvent.touches[0]
    else
      event

  class PanController

    events:
      # TODO "doubletap": "goToNow"
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
        flickDecay: 0.8
        slowPanSpeed: 20000   # ms/pixel
        fastPanSpeed: 200000  # ms/pixel

    goToNow: (ev) =>
      ev.preventDefault()
      ev.stopPropagation()
      @model.setTime( Date.now() )

    startMove: (ev) =>
      ev.preventDefault()
      ev.stopPropagation()
      @endMomentum()
      x = getTouch(ev).pageX
      @move = 
        x: x
        time: @model.time
      false

    pan: (ev) =>
      if @move?
        x = getTouch(ev).pageX
        distance = x - @move.x

        # If two fingers, double the pan effect
        rate = if ev.originalEvent.touches?.length > 1 then @settings.fastPanSpeed else @settings.slowPanSpeed
        distance *= rate
        
        @model.setTime( @move.time - distance )

        if @move.lastTime and ev.timeStamp != @move.lastTime
          @move.speed = (distance-@move.lastDistance) / (ev.timeStamp - @move.lastTime)
        
        @move.lastTime = ev.timeStamp
        @move.lastDistance = distance

        ev.preventDefault()
        ev.stopPropagation()
      false

    endMove: (ev) =>
      if ev.originalEvent.touches?.length > 0
        @startMove(ev)
        return

      return unless @move?

      if Math.abs(@move.speed) > @settings.flickThreshold
        @momentum = 
          speed: @move.speed
          handle: setInterval(@continueMomentum, @settings.flickUpdatePeriod)

      @move = null  

    continueMomentum: () =>
      @model.setTime( @model.time - @momentum.speed*@settings.flickUpdatePeriod )
      @momentum.speed *= @settings.flickDecay
      @endMomentum() if Math.abs(@momentum.speed) < @settings.flickEndSpeed

    endMomentum: () ->
      clearInterval(@momentum.handle) if @momentum
      @momentum = null

    dispose: () ->
      @unbindEvents()


  _.extend(PanController::, DomEvents)

  PanController