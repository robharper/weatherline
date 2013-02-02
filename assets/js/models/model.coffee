define ['_'], (_) ->

  class Model
    
    constructor: (data, options) ->
      _.extend(@, data || {})
      @_eventListeners = {}
      @init?(data, options)

    on: (event, handler, context) ->
      handlers = @_eventListeners[event] || []
      return @ if handlers.indexOf(handler) >= 0
      handlers.push({handler: handler, context: context})
      @_eventListeners[event] = handlers
      @

    off: (event, handler, context) ->
      @_eventListeners[event] = _.reject @_eventListeners, (desc) ->
        desc.handler == handler || (!handler and desc.context == context)
      @

    trigger: (event, payload...) ->
      for desc in (@_eventListeners[event] || [])
        desc.handler.apply(desc.context, payload)
      @

  Model