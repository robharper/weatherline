define (require) ->
  $ = require('$')
  moment = require('moment')

  # Models
  Days = require('models/days')
  Day = require('models/day')
  CurrentTime = require('models/momentModel')
  Sun = require('models/sun')

  # Controllers
  PanController = require('controllers/panController')
  
  # Views
  SkyView = require('views/sky')
  TimeView = require('views/timeDisplay')
  SatelliteView = require('views/satellite')

  FlipView = require('views/pageFlip')

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
        childViews: [
          new SatelliteView( model: @sun, currentTime: @currentTime )
          new FlipView(
            currentTime: @currentTime
            viewFactory: (date) ->
              new TimeView( date: date, currentTime: @currentTime )
          )
          
        ]
      )

      skyView.render().addTo(mainEl)