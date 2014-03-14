require 'coffee-errors'
{assert} = require 'chai'

load = require '../../src/blueprint-loader'

describe 'load()', () ->

  describe 'returns', () ->
    describe 'valid blueprint', () ->
      success = (ast) ->
        assert.fail
        assert.isObject ast
      error = (msg) ->
        assert.fail msg, null, 'should not be called'

      it 'will call success callback', () ->
        load __dirname + '/../fixtures/apiary.apib', success, error

    describe 'invalid blueprint', () ->
      success = (ast) ->
        assert.fail ast, null, 'should not be called'
      error = (msg) ->
        assert.isObject msg
        assert.include Object.keys(msg), 'code'

      it 'will call error callback', () ->
        load __dirname + '/../fixtures/error-blueprint.apib', success, error

    describe 'invalid path', () ->
      success = (ast) ->
        assert.fail ast, null, 'should not be called'
      error = (msg) ->
        assert.isObject msg
        assert.include Object.keys(msg), 'code'

      it 'will call error callback', () ->
        load __dirname + '/../fixtures/not-exists.apib', success, error
