class ResponseBuilder
  constructor: () ->
    @statusCode = undefined
    @headers = {}
    @setBody '{}'

  setStatusCode: (statusCode) ->
    @statusCode = parseInt statusCode

  setHeader: (name, value) ->
    @headers[name.toLowerCase()] = value

  setBody: (body) ->
    @body = body

  toResponseObject: () ->
    object =
      statusCode: @statusCode
      headers: @headers
      body: @body
    return object

module.exports = ResponseBuilder
