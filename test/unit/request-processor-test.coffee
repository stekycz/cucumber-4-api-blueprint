require 'coffee-errors'
{assert} = require 'chai'
nock = require 'nock'

RequestBuilder = require '../../src/request-builder'
RequestProcessor = require '../../src/request-processor'

describe 'RequestProcessor', () ->
  instance = null
  beforeEach () ->
    request = new RequestBuilder 'localhost', '3334'
    request.setMethod 'GET'
    request.setUriTemplate '/api/v1/gists'
    instance = new RequestProcessor request

  describe 'constructor', () ->
    it 'should create new instance', () ->
      assert.isObject instance
      assert.instanceOf instance, RequestProcessor

  describe 'process', () ->
    before () ->
      nock.disableNetConnect()
    scope = null
    beforeEach () ->
      scope = nock('http://localhost:3334').get('/api/v1/gists').once().reply(200)
    afterEach () ->
      scope.done()

    it 'should send the request and receive the response', () ->
      instance.process (response) ->
        assert.success
      , (msg) ->
        assert.fail msg
