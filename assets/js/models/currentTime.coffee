define ['moment', './model'], (moment, Model) ->

  class CurrentTime extends Model
    init: () ->
      @time = moment(+ (new Date()))

    setTime: (time) ->
      @time = moment(time)
      @trigger('change', @time)
      @

    format: (str) ->
      @time.format(str)

    valueOf: () ->
      @time.valueOf()


  CurrentTime