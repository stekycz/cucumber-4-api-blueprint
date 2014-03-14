World = require './world'
RequestBuilder = require './request/request-builder'
BlueprintLoader = require './blueprint-loader'
url = require 'url'

class ApiBlueprintStepDefinitionsWrapper
  constructor: () ->
    this.World = World

    this.Given /^API Blueprint in file "([^"]+)"$/, (filepath, callback) ->
      self = this
      BlueprintLoader filepath, (ast) ->
        self.ast = ast
        callback()
      , (error) ->
        callback.fail error

    this.Given /^base url (.*)$/, (baseUrl, callback) ->
      @baseUrl = url.parse baseUrl
      callback()

    this.When /^I do action (.*)$/, (action, callback) ->
      @reset()
      structure = action.split /\s*>\s*/
      callback.fail 'Action path is not complete' if structure.length < 3

      filteredGroups = @ast.resourceGroups.filter (group) ->
        return group.name == structure[0]
      callback.fail 'Group "' + structure[0] + '" was not found' if filteredGroups.length < 1
      @structure.group = filteredGroups[0]

      filteredResources = @structure.group.resources.filter (resource) ->
        return resource.name == structure[1]
      callback.fail 'Resource "' + structure[1] + '" was not found' if filteredResources.length < 1
      @structure.resource = filteredResources[0]

      filteredActions = @structure.resource.actions.filter (action) ->
        return action.name == structure[2]
      callback.fail 'Action "' + structure[2] + '" was not found' if filteredActions.length < 1
      @structure.action = filteredActions[0]

      @request = new RequestBuilder @baseUrl['hostname'], @baseUrl['port']
      @request.setMethod @structure.action.method
      @request.setUriTemplate @structure.resource.uriTemplate

      callback()

    this.When /^the request message body is(?: (\w+))?$/, (contentType, body, callback) ->
      @reset()
      contentType = @contentTypes[contentType] if @contentTypes[contentType]?
      @request.setHeader 'content-type', contentType
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
      contentType = this.contentTypes[contentType] if this.contentTypes[contentType]?
      this.expectedResponse.headers['content-type'] = contentType
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
