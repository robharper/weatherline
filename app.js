
/**
 * Module dependencies.
 */

var express = require('express')
  , http = require('http')
  , roots = require('roots-express')
  , assets = require('connect-assets')
  , path = require('path');

require('coffee-script');
var routes = require('./routes')

var app = express();
roots.add_compiler(assets);

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(assets());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

app.get('/weather', routes.weather);

var server = http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});

roots.watch(server);