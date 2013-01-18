define ['handlebars', './view'], (Handlerbars, View) ->

  class WeatherView extends View
    className: 'view'
    
    template: Handlebars.compile("""
      <h2>{{symbol}}</h2>
    """)

    init: (options) ->
      options ?= {}
      @symbol = options.symbol

    render: () ->
      @$el.html( @template(
        symbol: @symbol
      ))
      @
