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
  forecast = [];
  _(json.weatherdata.product[0].time).each( (record) ->
    forecast.push(
      from: record.$.from,
      to: record.$.to,
      symbol: record.location?[0].symbol?[0].$
    )
  )
  forecast = _.filter(forecast, (f) -> f.symbol?)
  res.send(forecast)