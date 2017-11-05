should = require 'should'
http = require 'http'
assert = require('assert')

server = require '../src/server.coffee'


describe 'server', () ->
  before () ->
    server.listen 8000
  
  describe '/', () ->
    it 'should return 200', (done) ->
      http.get 'http://localhost:8000', (res) ->
        assert.equal 200, res.statusCode
        done()

  describe '/about', () ->
    it 'should return 200', (done) ->
      http.get 'http://localhost:8000/about', (res) ->
        assert.equal 200, res.statusCode
        done()

  describe '/public/*', () ->
    it 'should return 200', (done) ->
      http.get 'http://localhost:8000/public/images/favicon.ico', (res) ->
        assert.equal 200, res.statusCode
        done()

  describe 'Bad request', () ->
    it 'should return 404', (done) ->
      http.get 'http://localhost:8000/bad', (res) ->
        assert.equal 404, res.statusCode
        
        data = ''

        res.on 'data', (chunk) ->
          data += chunk

        res.on 'end', () ->
          assert.equal 'Route not found\n', data
          
          http.get 'http://localhost:8000/bad/bad', (res) ->
            assert.equal 404, res.statusCode
            http.get 'http://localhost:8000/bad/bad/bad.jpg', (res) ->
              assert.equal 404, res.statusCode
              done()

  after () ->
    server.close()