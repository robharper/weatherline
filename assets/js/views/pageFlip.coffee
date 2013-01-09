define ['$', '_', './view', 'moment'], ($, _, View, moment) ->

  # A container view that shows a single child at a time and automatically
  # flips to prev/next children at the boundaries of the "pageSize" time unit
  class PageFlipView extends View

    className: "fill"

    DEFAULTS:
      pageSize: 'day'

    init: (options) ->
      @options = _.defaults(options || [], @DEFAULTS)
      @factory = options.viewFactory
      
      @currentTime = options.currentTime
      @currentTime.on('change', @update, @)
      
    render: () ->
      # TODO Cleanup on rerender
       
      # Set begin and end of current page
      @begin = moment(@currentTime.time).startOf(@options.pageSize)
      @end = moment(@currentTime.time).endOf(@options.pageSize)

      # Set zero point of slider
      @zero = @begin

      @slider = $('<div></div>').addClass("flip-slider")
      @$el.empty().append(@slider)

      # Create current, next and prev pages
      @views = [
        {idx:  0, view: @factory(@begin)}
      ]

      for page in @views
        page.view.render().$el.css(
          position: 'absolute'
          left: "#{page.idx*100}%"
        )
        @slider.append(page.view.$el)

      @

    update: () ->
      # If still within current page, do nothing
      if @begin.valueOf() <= @currentTime.time <= @end.valueOf()
        return

      # Flip
      @begin = moment(@currentTime.time).startOf(@options.pageSize)
      @end = moment(@currentTime.time).endOf(@options.pageSize)

      # If we don't have the view for this time period, create it
      idx = @begin.diff(@zero, "#{@options.pageSize}s")
      if !_.find( @views, (page) -> page.idx == idx )
        view = @factory(@begin)
        view.render().$el.css(
          position: 'absolute'
          left: "#{idx*100}%"
        )
        @slider.append(view.$el)
        @views.push({idx: idx, view: view})

      @slider.css("-webkit-transform": "translateX(#{-idx*100}%)")

      # TODO Remove old views


