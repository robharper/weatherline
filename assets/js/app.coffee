define (require) ->
  $ = require('$')
  moment = require('moment')

  # Models
  FixedPage = require('models/fixedTimePage')
  CurrentTime = require('models/observableMoment')
  Sun = require('models/sun')
  ForecastPageModel = require('models/periodPageModel')

  # Controllers
  PanController = require('controllers/panController')
  
  # Views
  SkyView = require('views/sky')
  TimeView = require('views/timeDisplay')
  SatelliteView = require('views/satellite')

  FlipView = require('views/pageFlip')
  WeatherView = require('views/weather')


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

      @skyView = new SkyView(
        model: @sun
        currentTime: @currentTime
        childViews: [
          new SatelliteView( model: @sun, currentTime: @currentTime )
          new FlipView(
            id: "date-view"
            className: 'date-flip'
            model: new FixedPage(pageSize: "day")
            currentTime: @currentTime
            viewFactory: (page) ->
              new TimeView( format: "MMM Do, YYYY", currentTime: page.begin )
          )
          new TimeView( id: "time-view", format: "HH:mm:ss", currentTime: @currentTime )
        ]
      )

      @skyView.render().addTo(mainEl)

      $.ajax(
        url: '/weather'
      ).done (data) =>
        view = new FlipView(
          model: new ForecastPageModel(pages: data.periods)
          currentTime: @currentTime
          viewFactory: (page) -> new WeatherView(symbol: page.symbol) if page?
        )
        view.render().addTo(@skyView.$el)