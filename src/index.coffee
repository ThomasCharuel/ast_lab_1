server = require './server.coffee'
serverConf = require './conf.coffee'

# Starts the http server
server.listen serverConf.port, serverConf.address