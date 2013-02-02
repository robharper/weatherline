# This "page" model generates a page per time unit specified in the constructor
define ['_','moment', './model'], (_, moment, Model) ->

  class PeriodPageModel extends Model

    @DEFAULTS:
      beginKey: 'from'
      endKey: 'to'

    init: (options) ->
      @options = _.defaults(options, PeriodPageModel.DEFAULTS)
      @setPages( options.pages ) if options.pages?

    setPages: (pages) ->
      @pages = _.map(pages, (page) =>
        _.extend({}, page,
          begin: moment(page[@options.beginKey])
          end: moment(page[@options.endKey])
        )
      )
      @trigger('change')

    getPage: (time) ->
      _.find @pages, (page) ->
        page.begin.valueOf() <= time < page.end.valueOf()