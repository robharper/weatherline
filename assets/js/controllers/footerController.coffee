define ['$', '_', 'util/domevents'], ($, _, DomEvents) ->

  class FooterController

    events:
      "touchstart .reveal": "toggle"
      "touchstart #tools-now": "goToNow"

    constructor: (options) ->
      @$el = $(options.el)
      @currentTime = options.currentTime
      @bindEvents()

    goToNow: (ev) =>
      ev.preventDefault()
      ev.stopPropagation()
      @currentTime.setTime( Date.now() )

    toggle: (ev) =>
      ev.preventDefault()
      ev.stopPropagation()
      @$el.toggleClass("open")

    dispose: () ->
      @unbindEvents()


  _.extend(FooterController::, DomEvents)

  FooterController