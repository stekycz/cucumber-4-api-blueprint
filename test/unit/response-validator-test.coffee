require 'coffee-errors'
{assert} = require 'chai'

ResponseValidator = require '../../src/response-validator'

describe 'ResponseValidator', () ->
  describe 'constructor', () ->
    it 'should create new instance', () ->
      instance = new ResponseValidator {}, {}
      assert.isObject instance
      assert.instanceOf instance, ResponseValidator

  describe 'validate', () ->
    it 'should call success callback on valid response', () ->
      real =
        statusCode: 200,
        body: '{ status: "ok" }'
      expected =
        statusCode: 200,
        body: '{ status: "ok" }'
      instance = new ResponseValidator real, expected
      instance.validate () ->
        assert.ok true, 'validation is OK on valid response'
      , (msg) ->
        assert.fail real, expected, msg

    it 'should call error callback on invalid response', () ->
      real =
        statusCode: 404,
        body: ''
      expected =
        statusCode: 200,
        body: '{ status: "ok" }'
      instance = new ResponseValidator real, expected
      instance.validate () ->
        assert.fail real, expected, 'success callback should not be called on invalid response'
      , (msg) ->
        assert.ok msg, 'error message given to error callback on invalid response'
