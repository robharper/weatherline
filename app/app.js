
/**
 * Module dependencies.
 */

var express = require('express')
  , http = require('http')
  , compiler = require('connect-compiler')
  , path = require('path')
  , stylus = require('stylus');

require('coffee-script');
var routes = require('./routes')


var root = path.join(__dirname, '../')
var app = express();


app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/../views');
  app.set('view engine', 'ejs');

  app.use(stylus.middleware({
    src: root + '/assets',
    dest: root + '/public'
  }));
  
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  
  app.use(app.router);

  if( app.settings.env == 'development' ) {
    app.use(compiler({
      enabled : [ 'coffee' ],
      src     : path.join(__dirname, '../assets'),
      dest    : path.join(__dirname, '../public')
    }));
    
    // Straight-up no-compilation necessary assets like js libs and images
    app.use(express.static(path.join(__dirname, '../assets')));
  }

  // Public
  app.use(express.static(path.join(__dirname, '../public')));
});


app.configure('development', function(){
  app.use(express.errorHandler());
});


// Routes
app.get('/', routes.index);
app.get('/weather', routes.weather);


// Start
var server = http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
