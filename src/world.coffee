RequestBuilder = require './request/request-builder'
RequestProcessor = require './request/request-processor'
ResponseBuilder = require './response/response-builder'
ResponseValidator = require './response/response-validator'
BlueprintActionFinder = require './blueprint-action-finder'
load = require './blueprint-loader'
url = require 'url'

class World
  constructor: (callback) ->
    @actionFinder = null
    @baseUrl = null
    @structure = null
    @request = null
    @reset()
    callback()

  reset: () ->
    @expectedResponse = new ResponseBuilder
    @response = null

  getRequest: () ->
    if !@request? and !@response?
      @request = new RequestBuilder @baseUrl['hostname'], @baseUrl['port']
    return @request

  processRequest: (callback, errorCallback) ->
    return @validate callback, errorCallback if @response?

    processor = new RequestProcessor @request

    self = this
    processor.process (response) ->
      self.response = response
      self.validate callback, errorCallback
    , (error) ->
      errorCallback error

  validate: (callback, errorCallback) ->
    validator = new ResponseValidator @response, @expectedResponse.toResponseObject()
    validator.validate callback, errorCallback

  createActionFinder: (filepath, success, errorCallback) ->
    self = this
    load filepath, (ast) ->
      self.setBaseUrl ast.metadata.HOST.value if !@baseUrl? and ast.metadata?.HOST?.value?
      self.actionFinder = new BlueprintActionFinder ast
      success()
    , (error) ->
      errorCallback error

  setBaseUrl: (baseUrl) ->
    @baseUrl = url.parse baseUrl

  setAction: (action, success, errorCallback) ->
    try
      @structure = @actionFinder.find action
    catch error
      errorCallback error

    @getRequest().setMethod @structure.action.method
    @getRequest().setUriTemplate @structure.resource.uriTemplate

    success()

module.exports = World
