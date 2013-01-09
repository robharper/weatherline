define ['_', 'moment', './model'], (_, moment, Model) ->

  class ObservableMoment extends Model
    init: () ->
      @time = moment(+ (new Date()))

    setTime: (time) ->
      @time = moment(time)
      @trigger('change', @time)
      @

  # Mix in moment functions into Model
  for name, func of moment.fn
    # Create proxy function that calls underlying time object (but don't override existing if exists)
    ObservableMoment::[name] = ((fn) ->
      () -> @time[fn].apply(@time, arguments)
    )(name)


  ObservableMoment