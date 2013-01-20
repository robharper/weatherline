fs = require 'fs'
path = require('path')
glob = require 'glob'
{print} = require 'sys'
{spawn} = require 'child_process'
fsx = require 'fs-extra'
async = require 'async'
requirejs = require 'requirejs'

clean = (callback) ->
  console.log("Cleaning")
  fsx.remove('./build', () ->
    fsx.remove('./public', callback)
  )

buildCs = (callback) ->
  console.log("Compiling")
  coffee = spawn 'coffee', ['-c', '-b', '-o', 'build', 'assets']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    console.log data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

copyStatic = (callback) ->
  console.log("Copying")
  # Clean this up - needlessly copying js, use r.js full site build and copy all but .coffee
  glob("./assets/**/@(*.js|*.ico|*.png)", (er, files) ->
    console.log er if er?
    async.forEach(files, (file, done) ->
      dest = "./public/#{file[9..-1]}"
      async.series([
        (callback,err) -> 
          console.log err if err?
          fsx.mkdirs( path.dirname(dest), callback ) 
        (callback,err) -> 
          console.log err if err?
          fsx.copy(file, dest, callback)
      ], done)
    , callback)
  )

optimize = (callback) ->
  console.log("Optimizing")
  config =
    optimize: 'none'
    baseUrl: 'build/js'
    name: 'main'
    out: 'public/js/main.js'
    paths:
      '$': '../../assets/js/vendor/jquery'
      '_': '../../assets/js/vendor/underscore'
      'moment': '../../assets/js/vendor/moment'
      'handlebars': '../../assets/js/vendor/handlebars-1.0.0-rc.1'
    shim:
      '$': 
        exports: '$'
      '_':
        exports: '_'
      'moment':
        exports: 'moment'
      'handlebars': 
        exports: 'Handlebars'
    

  requirejs.optimize(config, (buildResponse) ->
    console.log("...built")
    callback()
  , (err) ->
    console.log(err)
  )

task 'build:clean', 'Clean out public', ->
  clean()

task 'build:cs', 'Build coffeescript assets/ to build/', ->
  buildCs()

task 'build:copy', 'Copy assets from assets/ to build/', ->
  copyStatic()

task 'build:optimize', 'Optimize to a single file', ->
  optimize()

task 'build', 'Build entire project', ->
  async.series([
    (callback) -> clean(callback)
    (callback) -> buildCs(callback)
    (callback) -> copyStatic(callback)
    (callback) -> optimize(callback)
  ])