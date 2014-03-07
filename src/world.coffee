gavel = require 'gavel'
http = require 'http'
https = require 'https'

class World
  constructor: (callback) ->
    @ast = null
    @baseUrl = null
    @structure =
      group: null
      resource: null
      action: null
    @request =
      headers: {}
      body: ''
      parameters: {}
    @expectedResponse =
      statusCode: undefined
      headers: {}
      body: '{}'
    @response = null
    @contentTypes =
      JSON: 'application/json'
      XML: 'application/xml'
    callback()

  reset: () ->
    @response = null

  processRequest: (callback, errorCallback) ->
    return callback() if @response?

    flatHeaders = @request.headers

    caseInsensitiveMap = {}
    for key, value of flatHeaders
      caseInsensitiveMap[key.toLowerCase()] = key

    if caseInsensitiveMap['content-length'] == undefined and @request.body != ''
      flatHeaders['Content-Length'] = @request.body.length

    options =
      host: @baseUrl['hostname']
      port: @baseUrl['port']
      path: @structure.resource.uriTemplate
      method: @structure.action.method
      headers: flatHeaders

    buffer = ''
    self = this

    handleRequest = (res) ->
      res.on 'data', (chunk) ->
        buffer = buffer + chunk

      req.on 'error', (error) ->
        errorCallback error if error

      res.on 'end', () ->
        self.response =
          headers: res.headers
          body: buffer
          statusCode: res.statusCode
        callback()

    req = http.request options, handleRequest

    req.write self.request.body if self.request.body != ''
    req.end()

  validate: (callback, errorCallback) ->
    real = @response
    expected = @expectedResponse
    gavel.isValid real, expected, 'response', (error, isValid) ->
      errorCallback error if error

      if isValid
        return callback()
      else
        gavel.validate real, expected, 'response', (error, result) ->
          errorCallback error if error
          message = ''
          for entity, data of result
            for entityResult in data['results']
              message += entity + ": " + entityResult['message'] + "\n"
          return errorCallback message

module.exports = World
