http = require 'http'
https = require 'https'

class RequestProcessor
  constructor: (@request) ->

  process: (success, errorCallback) ->
    flatHeaders = @request.headers

    caseInsensitiveMap = {}
    for key, value of flatHeaders
      caseInsensitiveMap[key.toLowerCase()] = key

    if caseInsensitiveMap['content-length'] == undefined and @request.body != ''
      flatHeaders['content-length'] = @request.body.length

    options =
      host: @request.host
      port: @request.port
      path: @request.uriTemplate
      method: @request.method
      headers: flatHeaders

    buffer = ''

    handleRequest = (res) ->
      res.on 'data', (chunk) ->
        buffer = buffer + chunk

      req.on 'error', (error) ->
        errorCallback error if error

      res.on 'end', () ->
        response =
          headers: res.headers
          body: buffer
          statusCode: res.statusCode
        success response

    req = http.request options, handleRequest
    req.write @request.body if @request.body != ''
    req.end()

module.exports = RequestProcessor
