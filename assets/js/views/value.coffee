define ['handlebars','./view'], (Handlebars, View) ->

  # Displays a value given by the model for the current time
  # XXX Fixed to temperature for now...
  class ValueView extends View
    className: 'view'

    template: Handlebars.compile("""
      <h2>
        <span class="sign">{{#if negative}}-{{/if}}</span>
        <span class="value">{{value}}</span>
        <span class="unit">&deg;C</span>
      </h2>
    """)

    init: (options) ->
      @key = options.key
      @model = options.model
      @currentTime = options.currentTime
      @currentTime.on('change', @render, @)
      @model.on('change', @render, @)

    render: () ->
      value = @model.getValue(@currentTime, @key)
      if value?
        @$el.html( @template(
          negative: value < 0
          value: Math.abs(value).toFixed(0) 
        ) )
      else
        @$el.empty()
      @

    dispose: () ->
      super()
      @currentTime.off(null, null, @)
      @model.off(null, null, @)