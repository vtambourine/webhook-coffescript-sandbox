path = require 'path'
glob = require 'glob'

handlers = {}
for file in glob.sync './*.js', {cwd: __dirname}
  name = path.basename file, '.js'
  handlers[name] = require file unless file.match 'index.js'

exports.handle = (name, event) ->
    handlers[name] event if handlers[name]
