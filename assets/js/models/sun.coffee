define ['_', './model', 'util/celeste'], (_, Model, Celeste) ->

  rad2Deg = 180/Math.PI
  deg2Rad = Math.PI/180
  
  # Represents a physical model of the sun as seen
  # from a given position on earth
  class Sun extends Model
    # Model defaults
    DEFAULTS:
      # Altitude of the sun at which time twilight ends
      twilightAngle: -6
      sunDiameter: 0.545


    init: (data, options) ->
      @options = _.extend({}, @DEFAULTS, options)

      @longitude = data.longitude
      @latitude = data.latitude

    # Sets or gets the current observer's position in lat/lon
    observer: (newValues) ->
      if newValues?
        @longitude = newValues.lon
        @latitude = newValues.lat
        @trigger('change', @)
        @
      else
        { latitude: @latitude, longitude: @longitude }

    # Returns an object containing altitude and azimuth of the sun
    # as seen from the observer's location
    skyPosition: (utc) ->
      # Calculate sun's mean longitude (approx)
      n = Celeste.unixDateToJulian(utc) - Celeste.J2000
      meanLongitude = 280.46 + 0.9856474*n
      
      # Coordinate conversions
      equatorial = Celeste.eclipticToEquatorial(
        longitude: meanLongitude * deg2Rad
        latitude: 0
      )
      
      Celeste.equatorialToHorizontal( _.extend(equatorial,
        latitude: @latitude * deg2Rad
        longitude: -@longitude * deg2Rad
        utc: utc
      ))

    # Returns a value between 0 and 1 where 0 is darkness, 1 is daylight
    # and values in between represent dawn/dusk semi-light
    percentDaylight: (utc) ->
      position = @skyPosition(utc)
      altitude = position.altitude * rad2Deg
      if altitude > @options.sunDiameter
        1
      else if altitude < @options.twilightAngle
        0
      else
        Math.cos((altitude-@options.sunDiameter)/(@options.twilightAngle-@options.sunDiameter) * Math.PI/2)

    # Returns approximate closest solar noon to given date
    solarNoon: (utc) ->
      n = Celeste.unixDateToJulian(utc) - Celeste.J2000 + @longitude/360
      n = Math.round(n + 0.5)
      j = Celeste.J2000 - @longitude/360 + n
      Celeste.julianDateToUnix(j)