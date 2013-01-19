define ['./view'], (View) ->

  class WeatherView extends View
    className: 'weather symbol'

    init: (options) ->
      options ?= {}
      @symbol = options.symbol

    render: () ->
      @$el.addClass("#{@symbol.toLowerCase()}")
      @
