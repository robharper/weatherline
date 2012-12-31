define ['./view', 'util/fn', 'util/color'], (View, Fn, Color) ->

  class SatelliteView extends View
    DEFAULTS:
      fullColor:  0xFFFF77
      setColor:   0xFC6231
      size: 30
      setStart: 0
      setEnd: -8

    className: 'satellite'

    init: (options) ->
      options = _.defaults(options || {}, @DEFAULTS)
      
      @sun = options.model
      @currentTime = options.currentTime
      @currentTime.on('change', @render, @)

      @fullColor = options.fullColor
      @setColor = options.setColor
      @size = options.size
      @setStart = options.setStart
      @setEnd = options.setEnd

    dispose: () ->
      @currentTime.off(null, null, @)

    render: () ->
      position = @sun.skyPosition(@currentTime.time)
      altitude = position.altitude * 180/Math.PI
      setPercent = 1 - Math.max(Math.min((altitude-@setEnd)/(@setStart-@setEnd), 1), 0)
      color = Color.colorLerp(@fullColor, @setColor, setPercent)
      color = "##{color.toString(16)}"

      size = Fn.easeInQuad(@size, 2*@size, setPercent)

      @$el.css(
        backgroundColor: color
        left: '50%'
        top:  "#{100 - 90*(altitude*(1+setPercent)/90)}%"
        width: "#{2*size}px"
        height: "#{2*size}px"
        'border-radius': "#{size}px"
        'margin-top': "-#{size}px"
        'margin-left': "-#{size}px"
      )
      @

      

   