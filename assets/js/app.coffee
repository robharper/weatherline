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

  class App
    constructor: () ->
      # Bootstrap some basic data for testing now
      @currentTime = new CurrentTime()
      @sun = new Sun(longitude: -79, latitude: 43)

    start: () ->
      mainEl = $('#main')
      
      panController = new PanController(
        el: mainEl
        model: @currentTime
      )

      # List of views for main display
      views = [
        new SkyView(
          model: @sun
          currentTime: @currentTime
        ),
        new TimeView( currentTime: @currentTime )
      ]

      for view in views
        view.render().addTo(mainEl)