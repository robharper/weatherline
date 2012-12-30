define ['backbone'], (Backbone) ->

  class Model
    constructor: (data, options) ->
      _.extend(@, data || {})
      @init?(data, options)

  _.extend(Model::, Backbone.Events)

  Model