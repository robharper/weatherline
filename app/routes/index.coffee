xml2js = require('xml2js');
http = require('http');
_ = require('underscore');

# Request once on startup for now (avoid too many requests during dev)
json = {};
http.request({
  host: 'api.yr.no',
  path: '/weatherapi/locationforecast/1.8/?lat=43&lon=-79'
}, (response) ->
  str = ''
  response.on('data', (chunk) -> str += chunk )
  response.on('end', () ->
    parser = new xml2js.Parser()
    parser.parseString(str, (err, result) -> json = result )
  )
).end()

# Simple endpoint returns formatted weather data
exports.weather = (req, res) ->
  result =
    points: []
    periods: []
  
  # Find forecast periods - filter out point measurements
  periods = _(json.weatherdata.product[0].time).filter (record) -> record.$.from != record.$.to
  # Group by period length
  periods = _(periods).groupBy (record) -> new Date(record.$.to) - new Date(record.$.from)

  # Take shortest duration set of periods
  shortest = Math.min.apply(Math,_(periods).keys())
  periods = periods[shortest]
  
  _(periods).each( (record) ->
    result.periods.push(
      from: record.$.from,
      to: record.$.to,
      symbol: record.location?[0].symbol?[0].$
    )
  )

  # Find point readings
  points = _(json.weatherdata.product[0].time).filter (record) -> record.$.from == record.$.to
  _(points).each( (record) ->
    result.points.push(
      time: record.$.from,
      temperature: record.location?[0].temperature?[0].$
      temperature: record.location?[0].temperature?[0].$
    )
  )

  res.send(result)
  # # res.send(json.weatherdata.product[0].time)