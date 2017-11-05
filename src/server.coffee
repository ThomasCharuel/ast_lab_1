http = require 'http'
routes = require './routes.coffee'

# Declare an http server
this.server = http.createServer(routes.logic)

exports.listen = () ->
  this.server.listen.apply this.server, arguments

exports.close = (callback) ->
  this.server.close callback