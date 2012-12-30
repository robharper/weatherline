define ['$', '_', 'util/domevents'], ($, _, DomEvents) ->

  CID = 0

  createElement = (tag, clazz, id) ->
    el = $("<#{tag}>")
    el.addClass(clazz) if clazz?
    el.attr("id", id) if id?
    el


  # A very basic view base-class with striking similarity to Backbone.View
  class View
    tagType: 'div'
    constructor: (options) ->
      @cid = CID++
      _.extend(@, _.pick(options || [], 'tagType', 'className', 'id'))
      @$el = createElement(@tagType, @className, @id)
      @bindEvents()
      @init?.apply(@, arguments)

    $: (selector) ->
      $(selector, @$el)

    dispose: () ->
      unbindEvents()

    addTo: (el, replace) ->
      if replace
        $(el).html(@$el)
      else
        $(el).append(@$el)
      @

    remove: () ->
      @dispose()
      @$el.remove()

  
  _.extend(View::, DomEvents)

  View


