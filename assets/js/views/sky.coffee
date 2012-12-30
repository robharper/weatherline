define ['./view', 'util/color'], (View, Color) ->

  class SkyView extends View
    className: 'fullscreen'

    init: (options) ->
      options ?= {}
      @model = options.model
      @currentTime = options.currentTime
      @currentTime.on('change', @render, @)

      for child in options.childViews || []
        child.render().addTo(@$el)

    dispose: () ->
      @currentTime.off(null, null, @)

    render: () ->
      daylight = @model.percentDaylight(@currentTime.time)
      color = Color.colorLerp(0x110022, 0x99AAFF, daylight)
      @$el.css('backgroundColor': "##{color.toString(16)}")
      @

   