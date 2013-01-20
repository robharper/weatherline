require.config
  shim:
    '$': 
      exports: '$'
    '_':
      exports: '_'
    'moment':
      exports: 'moment'
    'handlebars': 
      exports: 'Handlebars'
  paths:
    # '$': 'components/zepto/zepto'
    '$': 'vendor/jquery'
    '_': 'vendor/underscore'
    'moment': 'vendor/moment'
    'handlebars': 'vendor/handlebars-1.0.0-rc.1'

# this will fire once the required scripts have been loaded
require ['app'], (App) ->
  app = new App()
  $ ->
    app.start()
  