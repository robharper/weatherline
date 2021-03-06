define [], () ->
  # Utilities
  atan = Math.atan2
  acos = Math.acos
  asin = Math.asin
  tan = Math.tan
  cos = Math.cos
  sin = Math.sin

  radians = (deg) ->
    deg/180*Math.PI

  # Constants
  UnixEpochAsJulian = 2440587.5
  msPerDay = 1000*60*60*24
  radsPerHour = 15/180*Math.PI



  Celeste =

    EARTH:
      obliquity: radians(23.439)

    # Julian date at greenwich, Jan 1 2000 at noon
    J2000: 2451545

    # Julian Date from unix ms since epoch
    unixDateToJulian: (unix) ->
      (unix / msPerDay) + UnixEpochAsJulian

    # Unix ms since epoch date from julian date
    julianDateToUnix: (julian) ->
      (julian - UnixEpochAsJulian) * msPerDay

    # Greenwich (Mean) Sidereal Time from Julian Date
    julianDateToGMST: (julian) ->
      (18.697374558 + 24.06570982441908 * (julian-Celeste.J2000)) % 24

    #
    # Coordinate System Transformations:
    #
    eclipticToEquatorial: (params) ->
      latitude = params.latitude
      longitude = params.longitude
      obliquity = params.obliquity || Celeste.EARTH.obliquity
      {
        declination: asin( sin(latitude)*cos(obliquity) + cos(latitude)*sin(obliquity)*sin(longitude) ),
        rightAscension: atan( sin(longitude)*cos(obliquity) - tan(latitude)*sin(obliquity), cos(longitude) ),
        obliquity: obliquity
      }

    equatorialToEcliptic: (params) ->
      declination = params.declination
      obliquity = params.obliquity || Celeste.EARTH.obliquity
      
      # Either rightAscension
      rightAscension = params.rightAscension
      # or hourAngle plus localSidereal/longitude+time are needed
      hourAngle = params.hourAngle
      localSidereal = params.localSidereal
      longitude = params.longitude
      utc = params.utc

      if !rightAscension?
        localSidereal ?= Celeste.julianDateToGMST(Celeste.unixDateToJulian(utc)) * radsPerHour - longitude
        rightAscension = localSidereal - hourAngle

      {
        latitude: asin( sin(declination)*cos(obliquity) - cos(declination)*sin(obliquity)*sin(rightAscension) ),
        longitude: atan( sin(rightAscension)*cos(obliquity) + tan(declination)*sin(obliquity), cos(rightAscension) ),
      }

    equatorialToHorizontal: (params) ->
      # Required
      declination = params.declination      
      latitude = params.latitude

      # Either hourAngle
      hourAngle = params.hourAngle
      # or rightAsceion plus localSidereal/longitude+time are needed
      rightAscension = params.rightAscension
      localSidereal = params.localSidereal
      longitude = params.longitude
      utc = params.utc

      if !hourAngle?
        localSidereal ?= Celeste.julianDateToGMST(Celeste.unixDateToJulian(utc)) * radsPerHour - longitude
        hourAngle = localSidereal - rightAscension

      {
        altitude: asin( sin(latitude)*sin(declination) + cos(latitude)*cos(declination)*cos(hourAngle) )
        azimuth: atan( sin(hourAngle), cos(hourAngle)*sin(latitude) - tan(declination)*cos(latitude) )
        latitude: latitude
        localSidereal: localSidereal
      }


    horizontalToEquatorial: (params) ->
      # Required
      altitude = params.altitude      
      azimuth = params.azimuth
      latitude = params.latitude

      # Local Sidereal or longitude+utc are required
      localSidereal = params.localSidereal
      longitude = params.longitude
      utc = params.utc

      localSidereal ?= Celeste.julianDateToGMST(Celeste.unixDateToJulian(utc)) * radsPerHour - longitude

      {
        declination: asin( sin(latitude)*sin(altitude) - cos(latitude)*cos(altitude)*cos(azimuth) ),
        rightAscension: localSidereal - atan( sin(azimuth), cos(azimuth)*sin(latitude) + tan(altitude)*cos(latitude) ),
      }


