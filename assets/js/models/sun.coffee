define ['_', './model', 'util/celeste'], (_, Model, Celeste) ->
  
  # Represents a physical model of the sun as seen
  # from a given position on earth
  class Sun extends Model
    # Model defaults
    DEFAULTS:
      # Altitude of the sun at which time twilight ends
      twilightAngle: -6


    init: (data, options) ->
      @options = _.extend({}, @DEFAULTS, options)

      @longitude = data.longitude
      @latitude = data.latitude

    # Sets or gets the current observer's position in lat/lon
    observer: (newValues) ->
      if newValues?
        @longitude = newValues.longitude
        @latitude = newValues.latitude
      else
        return { latitude: @latitude, longitude: @longitude }

    # Returns an object containing altitude and azimuth of the sun
    # as seen from the observer's location
    skyPosition: (utc) ->
      # Calculate sun's mean longitude (approx)
      n = Celeste.unixDateToJulian(utc) - Celeste.J2000
      meanLongitude = 280.46 + 0.9856474*n
      
      # Coordinate conversions
      equatorial = Celeste.eclipticToEquatorial(
        longitude: meanLongitude / 180*Math.PI
        latitude: 0
      )
      return Celeste.equatorialToHorizontal( _.extend(equatorial,
        latitude: @latitude / 180*Math.PI
        longitude: -@longitude / 180*Math.PI
        utc: utc
      ))

    # Returns a value between 0 and 1 where 0 is darkness, 1 is daylight
    # and values in between represent dawn/dusk semi-light
    percentDaylight: (utc) ->
      position = @skyPosition(utc)
      altitude = position.altitude * 180/Math.PI
      if altitude > 0
        return 1
      else if altitude < @options.twilightAngle
        return 0
      else
        return (1 - altitude/@options.twilightAngle)