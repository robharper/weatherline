define ['handlebars','./view'], (Handlebars, View) ->

  # Displays a value given by the model for the current time
  # XXX Fixed to temperature for now...
  class ValueView extends View
    className: 'view'

    template: Handlebars.compile("""
      <h2>
        <span class="value">{{value}}</span>
        <span class="unit">&deg;C</span>
      </h2>
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