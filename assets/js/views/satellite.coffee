define ['./view', 'util/fn', 'util/color'], (View, Fn, Color) ->

  class SatelliteView extends View
    DEFAULTS:
      fullColor:  0xFFFF77
      setColor:   0xF68878
      size: 30

    className: 'satellite'

    init: (options) ->
      options = _.defaults(options || {}, @DEFAULTS)
      
      @sun = options.model
      @sun.on('change', @render, @)

      @currentTime = options.currentTime
      @currentTime.on('change', @render, @)

      @fullColor = options.fullColor
      @setColor = options.setColor
      @size = options.size

    dispose: () ->
      @currentTime.off(null, null, @)
      @sun.off(null, null, @)
      super()

    render: () ->
      altitude = @sun.skyPosition(@currentTime.valueOf()).altitude
      highestToday = @sun.skyPosition( @sun.solarNoon(@currentTime.valueOf()) ).altitude

      risePercent = altitude / highestToday
      setPercent = 1 - @sun.percentDaylight(@currentTime.valueOf())
      
      color = Color.colorLerp(@fullColor, @setColor, setPercent)
      color = "##{color.toString(16)}"

      size = @size
      height = @$el.parent().height()

      @$el.css(
        backgroundColor: color
        left: '50%'
        top:  "#{100 - 75*risePercent}%"
        width: "#{2*size}px"
        height: "#{2*size}px"
        'border-radius': "#{size}px"
        'margin-top': "-#{size}px"
        'margin-left': "-#{size}px"
      )
      @

      

   