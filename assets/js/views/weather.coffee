define ['$', './view'], ($, View) ->

  class WeatherView extends View
    className: 'weather'

    init: (options) ->
      options ?= {}
      @symbol = options.symbol

    render: () ->
      $('<span>').addClass("symbol #{@symbol.toLowerCase()}")
        .appendTo(@$el)
      @
