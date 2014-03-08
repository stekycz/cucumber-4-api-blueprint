require 'coffee-errors'
{assert} = require 'chai'

load = require '../../src/blueprint-loader'

describe 'load()', () ->

  describe 'returns', () ->
    error = (msg) ->
      assert.fail msg, null, 'should not be called'

    success = (ast) ->
      assert.fail ast, null, 'should not be called'

    describe 'AST on success', () ->
      success = (ast) ->
        assert.isObject ast

      it 'OK', () ->
        load '../fixtures/apiary.apib', success, error

    describe 'error message on error', () ->
      error = (msg) ->
        assert.isObject msg
        assert.include Object.keys(msg), 'errno'
        assert.include Object.keys(msg), 'code'

      it 'OK', () ->
        load '../fixtures/error-blueprint.apib', success, error
