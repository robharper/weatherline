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
      @currentTime = options.currentTime
      @currentTime.on('change', @render, @)

      @fullColor = options.fullColor
      @setColor = options.setColor
      @size = options.size

    dispose: () ->
      @currentTime.off(null, null, @)

    render: () ->
      altitude = @sun.skyPosition(@currentTime.time).altitude
      highestToday = @sun.skyPosition( @sun.solarNoon(@currentTime.time) ).altitude

      risePercent = altitude / highestToday
      setPercent = 1 - @sun.percentDaylight(@currentTime.time)
      
      color = Color.colorLerp(@fullColor, @setColor, setPercent)
      color = "##{color.toString(16)}"

      size = @size
      height = @$el.parent().height()

      @$el.css(
        backgroundColor: color
        left: '50%'
        # Deg -> pixels: sun diameter px = 6 deg --> size/6px = 1 deg
        top:  "#{height - 0.75*height*risePercent - size}px"
        width: "#{2*size}px"
        height: "#{2*size}px"
        'border-radius': "#{size}px"
        'margin-top': "-#{size}px"
        'margin-left': "-#{size}px"
      )
      @

      

   