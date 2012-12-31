define (require) ->
  $ = require('$')
  moment = require('moment')

  # Models
  Days = require('models/days')
  Day = require('models/day')
  CurrentTime = require('models/currentTime')
  Sun = require('models/sun')

  # Controllers
  PanController = require('controllers/panController')
  
  # Views
  SkyView = require('views/sky')
  TimeView = require('views/timeDisplay')
  SatelliteView = require('views/satellite')

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
          new TimeView( currentTime: @currentTime )
          new SatelliteView( model: @sun, currentTime: @currentTime )
        ]
      )

      skyView.render().addTo(mainEl)