
/**
 * Module dependencies.
 */

var express = require('express')
  , http = require('http')
  , compiler = require('connect-compiler')
  , path = require('path');

require('coffee-script');
var routes = require('./routes')

var app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/../views');
  app.set('view engine', 'jade');
  
  app.use(compiler({
    enabled : [ 'coffee', 'stylus' ],
    src     : path.join(__dirname, '../assets'),
    dest    : path.join(__dirname, '../var')
  }));
  
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  
  app.use(app.router);

  // Three places to find static files :(
  // Public
  app.use(express.static(path.join(__dirname, '../public')));
  // Compiled styl / coffee
  app.use(express.static(path.join(__dirname, '../var')));
  // Straight-up no-compilation necessary assets like js libs
  app.use(express.static(path.join(__dirname, '../assets')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

// Routes
app.get('/weather', routes.weather);

// Start
var server = http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
