RequestProcessor = require './request/request-processor'
ResponseValidator = require './response/response-validator'

class World
  constructor: (callback) ->
    @actionFinder = null
    @baseUrl = null
    @request = null
    @expectedResponse =
      statusCode: undefined
      headers: {}
      body: '{}'
    @response = null
    callback()

  reset: () ->
    @response = null

  processRequest: (callback, errorCallback) ->
    return callback() if @response?

    processor = new RequestProcessor @request

    self = this
    processor.process (response) ->
      self.response = response
      callback()
    , (error) ->
      errorCallback error

  validate: (callback, errorCallback) ->
    validator = new ResponseValidator @response, @expectedResponse
    validator.validate callback, errorCallback

module.exports = World
