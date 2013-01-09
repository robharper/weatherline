define ['handlebars','./view'], (Handlebars, View) ->

  class TimeDisplayView extends View
    className: 'date-time'
    template: Handlebars.compile("""
      <h1>{{date}}</h1>
      <h2>{{time}}</h2>
    """)

    init: (options) ->
      options ?= {}
      @date = options.date
      @currentTime = options.currentTime
      @currentTime.on('change', @render, @)

    render: () ->
      @$el.html( @template(
        date: @date.format("MMMM Do YYYY")
        time: @currentTime.format("H:mm:ss a")
      ))
      @

    dispose: () ->
      @currentTime.off(null, null, @)