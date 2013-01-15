
/**
 * Module dependencies.
 */

var express = require('express')
  , http = require('http')
  , compiler = require('connect-compiler')
  , path = require('path');

require('coffee-script');
require('./lib/noop-compiler');
var routes = require('./routes')

var app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(compiler({
    enabled : [ 'coffee', 'stylus', 'js-noop' ],
    src     : 'assets',
    dest    : 'var'
  }));
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'var')));
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

// app.get('/', routes.index);
app.get('/weather', routes.weather);

var server = http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
