define ['handlebars','./view'], (Handlebars, View) ->

  class TimeDisplayView extends View
    className: 'date-time'
    
    template: Handlebars.compile("""
      <h2>{{time}}</h2>
    """)

    init: (options) ->
      options ?= {}
      @format = options.format
      @currentTime = options.currentTime
      @currentTime.on?('change', @render, @)

    render: () ->
      @$el.html( @template(
        time: @currentTime.format(@format)
      ))
      @

    dispose: () ->
      @currentTime.off?(null, null, @)