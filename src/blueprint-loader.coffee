fs = require 'fs'
protagonist = require 'protagonist'

load = (blueprintPath, success, error) ->
  fs.readFile blueprintPath, 'utf8', (parseError, data) ->
    return error(parseError) if parseError
    protagonist.parse data, (protagonistError, result) =>
      return error(protagonistError) if protagonistError
      success(result.ast)

module.exports = load
