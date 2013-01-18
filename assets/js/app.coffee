define (require) ->
  $ = require('$')
  moment = require('moment')

  # Models
  FixedPage = require('models/fixedTimePage')
  CurrentTime = require('models/observableMoment')
  Sun = require('models/sun')
  ForecastPageModel = require('models/periodPageModel')
  InterpolatedModel = require('models/interpolatedModel')

  # Controllers
  PanController = require('controllers/panController')
  
  # Views
  SkyView = require('views/sky')
  TimeView = require('views/timeDisplay')
  SatelliteView = require('views/satellite')

  FlipView = require('views/pageFlip')
  WeatherView = require('views/weather')
  ValueView = require('views/value')


  class App
    constructor: () ->
      # Bootstrap some basic data for testing now
      @currentTime = new CurrentTime()
      @sun = new Sun(longitude: -79, latitude: 43)

    start: () ->
      mainEl = $('#main')

      $('body').on 'touchmove', (ev) ->
        ev.preventDefault()

      panController = new PanController(
        el: mainEl
        model: @currentTime
      )

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
          new TimeView( format: "MMM Do, YYYY", currentTime: page.begin )
      )
      dateView.setElement($('#view-date')).render()

      timeView = new TimeView( id: "time-view", format: "HH:mm:ss", currentTime: @currentTime )
      timeView.setElement($('#view-time')).render()

      $.ajax(
        url: '/weather'
      ).done (data) =>
        view = new FlipView(
          model: new ForecastPageModel(pages: data.periods)
          currentTime: @currentTime
          viewFactory: (page) -> new WeatherView(symbol: page.symbol) if page?
        )
        view.setElement($('#view-symbol')).render()

        tempView = new ValueView(
          model: new InterpolatedModel(points: data.points)
          currentTime: @currentTime
          key: 'temperature'
        )
        tempView.setElement($('#view-temperature')).render()