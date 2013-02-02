# This "page" model generates a page per time unit specified in the constructor
# It is a generated model, not a true data storage
define ['$','./model'], ($, Model) ->

  class AsyncForecastModel extends Model

    @DEFAULTS = 
      lat: 43
      lon: -79
      url: '/weather'

    init: (options) ->
      @options = _.extend(options, AsyncForecastModel.DEFAULTS)
      @setLocation(@options.lat, @options.lon)

    setLocation: (lat, lon) ->
      @pendingRequest?.abort()

      @pendingRequest = $.ajax(
        url: @options.url
        data:
          lat: lat
          lon: lon
      ).done (data) =>
        @setData( data )

    setData: (data) ->
      @data = data
      @trigger('change', @)

    get: (subset) ->
      return unless @data?
      if subset?
        @data[subset]
      else
        @data