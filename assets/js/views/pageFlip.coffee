define ['$', '_', './view', 'moment'], ($, _, View, moment) ->

  # A container view that shows a single child at a time and automatically
  # flips to prev/next children at the boundaries of the "pageSize" time unit
  class PageFlipView extends View

    className: ""

    currentIdx: 0

    DEFAULTS: {}

    init: (options) ->
      @options = _.defaults(options || [], @DEFAULTS)
      @factory = options.viewFactory
      @model = options.model
      
      @currentTime = options.currentTime
      @currentTime.on('change', @update, @)
      
    render: () ->
      # TODO Cleanup on rerender
      @currentView?.dispose().remove()
      @slider = $('<div></div>').addClass("flip-slider")
      @$el.empty().append(@slider)
      @update()
      @

    update: () ->
      # If still within current page, do nothing
      unless @currentPage? and @currentPage.begin.valueOf() <= @currentTime.time <= @currentPage.end.valueOf()
        # Outside current page or no current page
        newPage = @model.getPage(@currentTime)

        return unless newPage? or @currentPage?

        # Which direction do we move?
        # Handle case where new or current page doesn't exist
        if @lastSeen > @currentTime.valueOf()
          @currentIdx -= 1
        else
          @currentIdx += 1

        # Create new view for page
        view = @factory(newPage) if newPage?
        if view?
          view.render().$el.css(
            position: 'absolute'
            left: "#{@currentIdx*100}%"
          )
          @slider.append(view.$el)

        # Flip
        @slider.css("-webkit-transform": "translateX(#{-@currentIdx*100}%)")

        # TODO Better removal logic
        oldView = @currentView
        @currentPage = newPage
        @currentView = view
        setTimeout((() -> oldView.dispose().remove()), 500) if oldView?

      @lastSeen = @currentTime.valueOf()
