url = require 'url'
render = require './render.coffee'

module.exports = 
  logic: (req, res) ->
    url = url.parse req.url
    [ _, directory, filetype, filename ] = url.pathname.split "/"
    directory = "/" if directory == ""
    console.log directory
    
    switch directory
      when "/"
        render.renderRessource "index.pug", "html", res
      when "about"
        render.renderRessource "about.pug", 'html', res
      when "public"
        render.renderRessource filename, filetype, res
      else 
        res.writeHead 404, 
          'Content-Type': 'text/plain'
        res.end 'Route not found\n'
    
  port: "8888"
  address: "127.0.0.1"