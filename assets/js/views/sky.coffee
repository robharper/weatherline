define ['./view', 'util/color'], (View, Color) ->

  class SkyView extends View
    className: 'sky'

    DEFAULTS:
      dayColor:   0x99AAFF
      dayColorTop:   0x7790E0
      setColor:   0xFFAAAA
      nightColor: 0x110022
      nightColorTop: 0x070012


    init: (options) ->
      options = _.defaults(options || {}, @DEFAULTS)
      
      @sun = options.model
      @currentTime = options.currentTime
      @currentTime.on('change', @updateBackground, @)

      @dayColor = options.dayColor
      @dayColorTop = options.dayColorTop
      @nightColor = options.nightColor
      @nightColorTop = options.nightColorTop
      @setColor = options.setColor

      @childViews = options.childViews || []

    dispose: () ->
      @currentTime.off(null, null, @)
      super()

    render: () ->
      @updateBackground()

      # Ugly: inject children into parent view by finding containers that match view's id
      for child in @childViews
        container = @$("##{child.id}")
        if container.length
          child.setElement(container).render()
        else
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

      color2 = Color.colorLerp(@nightColorTop, @dayColorTop, zenithDaylight)

      @$el.css('background': Color.toCss(color1))
      @$el.css('background': "-webkit-linear-gradient(top, #{Color.toCss(color2)} 0%, #{Color.toCss(color1)} 100%)")
      @$el.css('background': "linear-gradient(to bottom,  #{Color.toCss(color2)} 0%, #{Color.toCss(color1)} 100%)")
      @

   