compiler = require('connect-compiler')

class Noop extends compiler.Compiler
  id: 'js-noop'
  match: /\.js?$/i;
  ext: '.js'
  compileSync: (text, options) -> text

compiler.register( Noop )

exports = Noop