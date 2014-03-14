class RequestBuilder
  constructor: (@host, @port) ->
    @method = null
    @uriTemplate = null
    @setBody ''
    @headers = {}
    @parameters = {}

  setMethod: (method) ->
    @method = method

  setUriTemplate: (uriTemplate) ->
    @uriTemplate = uriTemplate

  setBody: (body) ->
    @body = body

  setHeader: (name, value) ->
    @headers[name.toLowerCase()] = value

  setParameter: (name, value) ->
    @parameters[name] = value



module.exports = RequestBuilder
