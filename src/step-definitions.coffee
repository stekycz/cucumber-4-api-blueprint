World = require './world'
contentTypeTranslate = require './content-type-translator'
statusCodeTranslate = require './status-code-translator'

class ApiBlueprintStepDefinitionsWrapper
  constructor: () ->
    this.World = World

    this.Given /^API Blueprint in file "([^"]+)"$/, (filepath, callback) ->
      @createActionFinder filepath, callback, callback.fail

    this.Given /^base url (.*)$/, (baseUrl, callback) ->
      @setBaseUrl baseUrl
      callback()

    this.When /^I do action (.*)$/, (action, callback) ->
      @reset()
      @setAction action, callback, callback.fail

    this.When /^the request message body is(?: (\w+))?$/, (contentType, body, callback) ->
      @reset()
      @getRequest().setHeader 'Content-Type', contentTypeTranslate(contentType)
      @getRequest().setBody body

      callback()

    this.Then /It should be ([^()]+)(?: \((\d+)\))?$/, (name, code, callback) ->
      code = statusCodeTranslate name if !code
      @expectedResponse.setStatusCode code ? parseInt(code)
      @processRequest callback, callback.fail

    this.Then /^the response message body is(?: (\w+))?$/, (contentType, body, callback) ->
      @expectedResponse.setHeader 'Content-Type', contentTypeTranslate(contentType)
      @expectedResponse.setBody body
      @processRequest callback, callback.fail

module.exports = ApiBlueprintStepDefinitionsWrapper
