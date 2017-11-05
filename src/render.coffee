fs = require 'fs'
pug = require 'pug'
stylus = require 'stylus'

routeNotFound = (res) ->
  res.writeHead 404, 
    'Content-Type': 'text/plain'
  res.end 'Route not found\n'

module.exports = 
  renderRessource: (filename, type, res) ->
    switch type
      when "html"
        # pug rendering
        console.log "rendering pug resource #{filename}"
        try
          pug.renderFile "views/#{filename}", 
            pretty: true
          , (err, html) ->
            throw err if err 
            res.writeHead 200, 
              'Content-Type': "text/#{type}"
            res.write html
            res.end()
        catch err
          routeNotFound res
        
      when "stylus"
        # css => stylus rendering
        console.log "rendering stylus resource #{filename}"
        try
          file = fs.readFileSync "stylesheets/#{filename}", "utf-8"
          stylus.render file, { filename: "stylesheets/#{filename}" }, 
            (err, css) ->
              throw err if err
              res.writeHead 200,
                'Content-Type': "text/css"
              res.write css
              res.end()
        catch err
          routeNotFound res

      else
        # render the file
        console.log "rendering resource #{filename} of type #{type}"
        try
          file = fs.readFileSync "public/#{type}/#{filename}"
          res.writeHead 200, 
            'Content-Type': "text/#{type}"
          res.write file
          res.end()
        catch err
          routeNotFound res