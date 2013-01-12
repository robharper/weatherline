define ['$', '_', './view', 'moment'], ($, _, View, moment) ->

  # A container view that shows a single child at a time and automatically
  # flips to prev/next children at the boundaries of the "pageSize" time unit
  class PageFlipView extends View

    className: "fill"

    DEFAULTS: {}

    init: (options) ->
      @options = _.defaults(options || [], @DEFAULTS)
      @factory = options.viewFactory
      @model = options.model
      
      @currentTime = options.currentTime
      @currentTime.on('change', @update, @)
      
    render: () ->
      # TODO Cleanup on rerender

      @slider = $('<div></div>').addClass("flip-slider")
      @$el.empty().append(@slider)

      # Create current
      @currentIdx = 0
      @currentPage = @model.getPage(@currentTime.time)
      @currentView = @factory(@currentPage)

      @currentView.render().$el.css(
        position: 'absolute'
        left: "#{@currentIdx*100}%"
      )
      @slider.append(@currentView.$el)

      @

    update: () ->
      # If still within current page, do nothing
      if @currentPage.begin.valueOf() <= @currentTime.time <= @currentPage.end.valueOf()
        return

      # Flip
      newPage = @model.getPage(@currentTime.time)

      # Which direction do we move?
      if newPage.begin.valueOf() < @currentPage.begin.valueOf()
        @currentIdx -= 1
      else
        @currentIdx += 1

      view = @factory(newPage)
      view.render().$el.css(
        position: 'absolute'
        left: "#{@currentIdx*100}%"
      )
      @slider.append(view.$el)

      @slider.css("-webkit-transform": "translateX(#{-@currentIdx*100}%)")

      # TODO Better removal logic
      oldView = @currentView
      @currentPage = newPage
      @currentView = view
      setTimeout((() -> oldView.dispose().remove()), 500)
