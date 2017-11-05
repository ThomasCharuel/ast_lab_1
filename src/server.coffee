fs = require 'fs'
url = require 'url'
pug = require 'pug'
stylus = require 'stylus'

renderResource = (filename, type, res) ->
  switch type
    when "html"
      # pug rendering
      console.log "rendering pug resource #{filename}"
      pug.renderFile "views/#{filename}", 
        pretty: true
      , (err, html) ->
        throw err if err 
        res.writeHead 200, 
          'Content-Type': "text/#{type}"
        res.write html
        res.end()
      
    when "stylus"
      # css => stylus rendering
      console.log "rendering stylus resource #{filename}"
      file = fs.readFileSync "stylesheets/#{filename}", "utf-8"
      stylus.render file, { filename: "stylesheets/#{filename}" }, 
        (err, css) ->
          throw err if err
          res.writeHead 200,
            'Content-Type': "text/css"
          res.write css
          res.end()

    else
      # render the file
      console.log "rendering resource #{filename} of type #{type}"
      fs.readFile "public/#{type}/#{filename}", (err, file) ->
        throw err if err 
        res.writeHead 200, 
          'Content-Type': "text/#{type}"
        res.write file
        res.end()


module.exports = 
  logic: (req, res) ->
    url = url.parse req.url
    [ _, directory, filetype, filename ] = url.pathname.split "/"
    directory = "/" if directory == ""
    console.log directory
    
    switch directory
      when "/"
        renderResource "index.pug", "html", res
      when "about"
        renderResource "about.pug", 'html', res
      when "public"
        renderResource filename, filetype, res
      else 
        res.writeHead 404, 
          'Content-Type': 'text/plain'
        res.end 'Route not found\n'
    
  port: "8888"
  address: "127.0.0.1"