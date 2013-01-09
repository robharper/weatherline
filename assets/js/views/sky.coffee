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
      daylight = @sun.percentDaylight(@currentTime.valueOf())
      zenithDaylight = Math.max(daylight - 0.2, 0)

      if daylight < 0.5 
        color1 = Color.colorLerp(@nightColor, @setColor, daylight/0.5)
        @$el.addClass("night-sky").removeClass("day-sky")
      else
        color1 = Color.colorLerp(@setColor, @dayColor, (daylight-0.5)/0.5)
        @$el.addClass("day-sky").removeClass("night-sky")

      color2 = Color.colorLerp(@nightColor, @dayColor, zenithDaylight)

      @$el.css('background': "##{color1.toString(16)}")
      @$el.css('background': "-webkit-linear-gradient(top, ##{color2.toString(16)} 0%, ##{color1.toString(16)} 100%)")
      @$el.css('background': "linear-gradient(to bottom,  ##{color2.toString(16)} 0%, ##{color1.toString(16)} 100%)")
      @

   