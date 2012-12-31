define ['./view', 'util/color'], (View, Color) ->

  class SkyView extends View
    className: 'sky'

    DEFAULTS:
      dayColor:   0x99AAFF
      setColor:   0xFFAAAA
      nightColor: 0x110022

    init: (options) ->
      options = _.defaults(options || {}, @DEFAULTS)
      
      @sun = options.model
      @currentTime = options.currentTime
      @currentTime.on('change', @updateBackground, @)

      @dayColor = options.dayColor
      @nightColor = options.nightColor
      @setColor = options.setColor

      @childViews = options.childViews || []

    dispose: () ->
      @currentTime.off(null, null, @)

    render: () ->
      @updateBackground()

      for child in @childViews
        child.render().addTo(@$el)

      @

    updateBackground: () ->
      daylight = @sun.percentDaylight(@currentTime.time)
      if daylight < 0.5 
        color = Color.colorLerp(@nightColor, @setColor, daylight/0.5)
        @$el.addClass("night-sky").removeClass("day-sky")
      else
        color = Color.colorLerp(@setColor, @dayColor, (daylight-0.5)/0.5)
        @$el.addClass("day-sky").removeClass("night-sky")
      @$el.css('backgroundColor': "##{color.toString(16)}")
      @

   