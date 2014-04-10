class RequestBuilder
  constructor: (@host, @port, @path) ->
    @method = null
    @uriTemplate = null
    @setBody ''
    @headers = {}
    @parameters = {}

  setMethod: (method) ->
    @method = method

  setUriTemplate: (uriTemplate) ->
    @uriTemplate = @path + uriTemplate

  setBody: (body) ->
    @body = body

  setHeader: (name, value) ->
    @headers[name.toLowerCase()] = value

  setParameter: (name, value) ->
    @parameters[name] = value

module.exports = RequestBuilder
