# This "page" model generates a page per time unit specified in the constructor
# It is a generated model, not a true data storage
define ['./model'], (Model) ->

  class FixedTimePageModel extends Model

    init: (options) ->
      @pageSize = options.pageSize

    getPage: (time) ->
      {
        begin: moment(time).startOf(@pageSize)
        end: moment(time).endOf(@pageSize)
      }