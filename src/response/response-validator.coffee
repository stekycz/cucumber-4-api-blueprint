gavel = require 'gavel'

class ResponseValidator
  constructor: (@real, @expected) ->

  validate: (success, errorCallback) ->
    real = @real
    expected = @expected
    gavel.isValid real, expected, 'response', (error, isValid) ->
      errorCallback error if error

      if isValid
        return success()
      else
        gavel.validate real, expected, 'response', (error, result) ->
          errorCallback error if error
          message = ''
          for entity, data of result
            for entityResult in data['results']
              message += entity + ": " + entityResult['message'] + "\n"
          return errorCallback message

module.exports = ResponseValidator
