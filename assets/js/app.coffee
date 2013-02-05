define (require) ->
  $ = require('$')
  moment = require('moment')

  # Models
  FixedPage = require('models/fixedTimePage')
  CurrentTime = require('models/observableMoment')
  Sun = require('models/sun')
  AsyncForecastModel = require('models/asyncForecastModel')
  ForecastPageModel = require('models/forecastPageModel')
  InterpolatedModel = require('models/interpolatedModel')

  # Controllers
  PanController = require('controllers/panController')
  FooterController = require('controllers/footerController')
  
  # Views
  SkyView = require('views/sky')
  TimeView = require('views/timeDisplay')
  SatelliteView = require('views/satellite')

  FlipView = require('views/pageFlip')
  WeatherView = require('views/weather')
  ValueView = require('views/value')

  DEFAULT_LOCATION =
    lat: 43
    lon: -79

  class App
    constructor: () ->
      # Bootstrap some basic data for testing now
      @currentTime = new CurrentTime()
      @sun = new Sun(DEFAULT_LOCATION)

    determineLocation: (cb) ->
      if navigator.geolocation
        navigator.geolocation.getCurrentPosition (position) ->
          cb(position.coords.latitude, position.coords.longitude)
      else
        # XXX No geolocation fix to Toronto
        cb(DEFAULT_LOCATION.lat, DEFAULT_LOCATION.lon)
      
    start: () ->
      mainEl = $('#main')

      $('body').on 'touchmove', (ev) ->
        ev.preventDefault()

      panController = new PanController(
        el: mainEl
        model: @currentTime
      )

      footerController = new FooterController(
        el: $('footer')
        currentTime: @currentTime
      )


      @currentTime.on('change', @modeChange, @)
      @modeChange()

      skyView = new SkyView(
        model: @sun
        currentTime: @currentTime
      )
      skyView.setElement($('#view-sky')).render()

      sunView = new SatelliteView( model: @sun, currentTime: @currentTime )
      sunView.setElement($('#view-sun')).render()

      dateView = new FlipView(
        id: "date-view"
        className: 'date-flip'
        model: new FixedPage(pageSize: "day")
        currentTime: @currentTime
        viewFactory: (page) ->
          new TimeView( format: "MMM D, YYYY", currentTime: page.begin )
      )
      dateView.setElement($('#view-date')).render()

      timeView = new TimeView( id: "time-view", format: "HH:mm", currentTime: @currentTime )
      timeView.setElement($('#view-time')).render()

      @determineLocation( @setLocation )

    modeChange: () =>
      daylight = @sun.percentDaylight(@currentTime)
      if daylight < 0.5 
        $('body').addClass("night").removeClass("day")
      else
        $('body').addClass("day").removeClass("night")

    setLocation: (lat, lon) =>
      @sun.observer(lat: lat, lon: lon)
      @forecastModel = new AsyncForecastModel(lat: lat, lon: lon)
      
      # TODO Create views once
      view = new FlipView(
        model: new ForecastPageModel(model: @forecastModel)
        currentTime: @currentTime
        viewFactory: (page) -> new WeatherView(symbol: page.symbol.id) if page?
      )
      view.setElement($('#view-symbol')).render()

      tempView = new ValueView(
        model: new InterpolatedModel(model: @forecastModel)
        currentTime: @currentTime
        key: 'temperature'
      )
      tempView.setElement($('#view-temperature')).render()