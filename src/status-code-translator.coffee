http = require 'http'

statusCodes = {}
statusCodes[http.STATUS_CODES[code].toLowerCase()] = code for code in Object.keys(http.STATUS_CODES)

translate = (statusCode) ->
  key = statusCode.toLowerCase()
  return parseInt statusCodes[key] if statusCodes[key]?
  return statusCode

module.exports = translate
