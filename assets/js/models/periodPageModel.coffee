# This "page" model generates a page per time unit specified in the constructor
# It is a generated model, not a true data storage
define ['_','moment', './model'], (_, moment, Model) ->

  class PeriodPageModel extends Model

    init: (options) ->
      @pages = _.map options.pages, (page) ->
        {
          begin: moment(page.from)
          end: moment(page.to)
          symbol: page.symbol.id
        }

    getPage: (time) ->
      _.find @pages, (page) ->
        page.begin.valueOf() <= time < page.end.valueOf()