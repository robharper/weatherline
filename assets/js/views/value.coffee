define ['handlebars','./view'], (Handlebars, View) ->

  class ValueView extends View
    template: Handlebars.compile("""
      <h2>{{value}}</h2>
    """)

    init: (options) ->
      @key = options.key
      @model = options.model
      @currentTime = options.currentTime
      @currentTime.on("change", @render, @)

    render: () ->
      @$el.html( @template(
        value: @model.getValue(@currentTime, @key).toFixed(1) 
      ) )
      @

    dispose: () ->
      super()
      @currentTime.off(null, null, @)