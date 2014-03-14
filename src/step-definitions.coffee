World = require './world'
RequestBuilder = require './request/request-builder'
load = require './blueprint-loader'
contentTypeTranslate = require './content-type-translator'
BlueprintActionFinder = require './blueprint-action-finder'
url = require 'url'

class ApiBlueprintStepDefinitionsWrapper
  constructor: () ->
    this.World = World

    this.Given /^API Blueprint in file "([^"]+)"$/, (filepath, callback) ->
      self = this
      load filepath, (ast) ->
        self.actionFinder = new BlueprintActionFinder ast
        callback()
      , (error) ->
        callback.fail error

    this.Given /^base url (.*)$/, (baseUrl, callback) ->
      @baseUrl = url.parse baseUrl
      callback()

    this.When /^I do action (.*)$/, (action, callback) ->
      @reset()
      try
        structure = this.actionFinder.find action
      catch error
        callback.fail error

      @request = new RequestBuilder @baseUrl['hostname'], @baseUrl['port']
      @request.setMethod structure.action.method
      @request.setUriTemplate structure.resource.uriTemplate

      callback()

    this.When /^the request message body is(?: (\w+))?$/, (contentType, body, callback) ->
      @reset()
      @request.setHeader 'content-type', contentTypeTranslate(contentType)
      @request.setBody body
      callback()

    this.Then /It should be ([^()]+)(?: \((\d+)\))?$/, (name, code, callback) ->
      this.expectedResponse.statusCode = parseInt code
      self = this
      @processRequest () ->
        self.validate () ->
          callback()
        , (msg) ->
          callback.fail msg
      , (msg) ->
        callback.fail msg

    this.Then /^the response message body is(?: (\w+))?$/, (contentType, body, callback) ->
      this.expectedResponse.headers['content-type'] = contentTypeTranslate(contentType)
      this.expectedResponse.body = body
      self = this
      @processRequest () ->
        self.validate () ->
          callback()
        , (msg) ->
          callback.fail msg
      , (msg) ->
        callback.fail msg

module.exports = ApiBlueprintStepDefinitionsWrapper
