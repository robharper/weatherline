define ['./model'], (Model) ->

  class CurrentTime extends Model
    init: () ->
      @time = + (new Date())

    setTime: (time) ->
      @time = time
      @trigger('change', @time)
      @

    format: (str) ->
      moment(@time).format(str)


  CurrentTime