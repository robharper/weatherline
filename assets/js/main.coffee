require.config
  shim:
    '$': 
      exports: '$'
    '_':
      exports: '_'
    'moment':
      exports: 'moment'
    'backbone': 
      deps: ['_', '$']
      exports: 'Backbone'
    'handlebars': 
      exports: 'Handlebars'
  paths:
    # '$': 'components/zepto/zepto'
    '$': 'components/jquery/jquery'
    '_': 'components/underscore/underscore'
    'moment': 'components/moment/moment'
    'backbone': 'components/backbone/backbone'
    'handlebars': 'components/handlebars/handlebars-1.0.0-rc.1'

# this will fire once the required scripts have been loaded
require ['app'], (App) ->
  app = new App()
  $ ->
    app.start()
  