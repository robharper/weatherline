# This "page" model generates a page per time unit specified in the constructor
# It is a generated model, not a true data storage
define ['_', './model', 'util/fn'], (_, Model, Fn) ->

  class InterpolatedModel extends Model

    init: (options) ->
      # Convert time to millis past epoch
      @points = _.map options.points, (point) ->
        point.time = moment(point.time).valueOf()
        point
      @points = _.sortBy @points, (point) -> point.time

    # Given a time (moment) and a value key, returns the interpolated value
    getValue: (time, key) ->
      idx = _.sortedIndex @points, {time: time.valueOf()}, (point) -> point.time
      if idx == 0
        # Beginning
        @valueAt(idx, key)
      else if idx == @points.length
        # End
        @valueAt(idx-1, key)
      else
        @interpolate( time, 
          @valueAt(idx-1,key), @points[idx-1].time, 
          @valueAt(idx,key),   @points[idx].time)

    valueAt: (idx, key) ->
      v = @points[idx][key]
      v = v.value if v.value?
      v = parseFloat(v) if _.isString(v)
      v

    interpolate: (t, v1, t1, v2, t2) ->
      Fn.lerp(v1, v2, (t-t1)/(t2-t1))