require 'coffee-errors'
{assert} = require 'chai'

load = require '../../src/blueprint-loader'
BlueprintActionFinder = require '../../src/blueprint-action-finder'

describe 'BlueprintActionFinder', () ->
  instance = null
  test = () ->
  beforeEach () ->
    load __dirname + '/../fixtures/apiary.apib', (ast) ->
      instance = new BlueprintActionFinder ast
      test()
    , (msg) ->
      assert.fail msg, null, 'API Blueprint loading failed'

  describe 'constructor', () ->
    it 'should create new instance', () ->
      test = () ->
        assert.isObject instance
        assert.instanceOf instance, BlueprintActionFinder

  describe 'find', () ->
    existsAction = 'Machines > Machines collection > Create a Machine'

    it 'should return object with 3 keys', () ->
      test = () ->
        result = instance.find existsAction
        assert.isObject result
        assert.equal Object.keys(result).length, 3

    it 'should return containing group', () ->
      test = () ->
        result = instance.find existsAction
        assert.property result, 'group'

    it 'should return containing resource', () ->
      test = () ->
        result = instance.find existsAction
        assert.property result, 'resource'

    it 'should return containing action', () ->
      test = () ->
        result = instance.find existsAction
        assert.property result, 'action'

    it 'should throw error on uncomplete action path', () ->
      test = () ->
        try
          instance.find 'Machines > Machines collection'
        catch error
          assert.equal error, 'Action path is not complete'

    it 'should throw error on unknown group', () ->
      test = () ->
        try
          instance.find 'Gists > Machines collection > Create a Machine'
        catch error
          assert.equal error, 'Group "Gists" was not found'

    it 'should throw error on unknown resource', () ->
      test = () ->
        try
          instance.find 'Machines > Gists collection > Create a Machine'
        catch error
          assert.equal error, 'Resource "Gists collection" was not found'

    it 'should throw error on unknown group', () ->
      test = () ->
        try
          instance.find 'Machines > Machines collection > Create a Gist'
        catch error
          assert.equal error, 'Action "Create a Gist" was not found'
