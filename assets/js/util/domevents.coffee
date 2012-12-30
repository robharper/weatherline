define [], () ->

  # A simple mixin that provides bind and unbind functions
  # that act on a hash of "event selector": "function name"
  DomEvents =
    bindEvents: () ->
      for key, callback of (@events || {})
        params = key.split(' ')
        @$el?.on(params.shift(), params.join(' '), @[callback])
      @

    unbindEvents: () ->
      for key, callback of (@events || {})
        params = key.split(' ')
        @$el?.off(params.shift(), params.join(' '), @[callback])
      @