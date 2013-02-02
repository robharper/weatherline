# This "page" model generates a page per time unit specified in the constructor
# It is a generated model, not a true data storage
define ['$','./periodPageModel'], ($, PageModel) ->

  class ForecastPageModel extends PageModel

    init: (options) ->
      @options = _.extend(options, @DEFAULT)
      super(@options)
      @forecastData = options.model
      @forecastData.on('change', @updateData, @)
      @updateData(@forecastData)

    updateData: (data) ->
      return unless data?
      @setPages( data.get('periods') )

    getPage: (time) ->
      super(time) if @pages?

    # TODO Model release