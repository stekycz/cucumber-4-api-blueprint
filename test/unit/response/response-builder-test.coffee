require 'coffee-errors'
{assert} = require 'chai'

ResponseBuilder = require '../../../src/response/response-builder'

describe 'ResponseBuilder', () ->
  instance = null
  beforeEach () ->
    instance = new ResponseBuilder

  describe 'constructor', () ->
    it 'should create new instance', () ->
      assert.isObject instance
      assert.instanceOf instance, ResponseBuilder

  describe 'setStatusCode', () ->
    it 'should set status code', () ->
      instance.setStatusCode 200
      assert.strictEqual instance.statusCode, 200

    it 'should be only integer value', () ->
      instance.setStatusCode '200'
      assert.strictEqual instance.statusCode, 200

  describe 'setBody', () ->
    it 'should set body', () ->
      instance.setBody ''
      assert.strictEqual instance.body, ''
      instance.setBody '{"status": "ok"}'
      assert.strictEqual instance.body, '{"status": "ok"}'

  describe 'setHeader', () ->
    it 'should set header by given name', () ->
      instance.setHeader 'content-type', 'application/json'
      assert.isObject instance.headers
      assert.propertyVal instance.headers, 'content-type', 'application/json'

    it 'should not be case sensitive', () ->
      instance.setHeader 'content-type', 'application/json'
      instance.setHeader 'Content-Type', 'application/hal+json'
      assert.isObject instance.headers
      assert.propertyVal instance.headers, 'content-type', 'application/hal+json'
      assert.notProperty instance.headers, 'Content-Type'

  describe 'toResponseObject', () ->
    beforeEach () ->
      instance.setStatusCode 200
      instance.setHeader 'content-type', 'application/json'
      instance.setBody '{"status": "ok"}'

    it 'should return response as simple object', () ->
      assert.isObject instance.toResponseObject()

    it 'should have property statusCode', () ->
      assert.propertyVal instance.toResponseObject(), 'statusCode', 200

    it 'should have property body', () ->
      assert.propertyVal instance.toResponseObject(), 'body', '{"status": "ok"}'

    it 'should have property headers', () ->
      assert.property instance.toResponseObject(), 'headers'

    it 'should return headers as simple object', () ->
      assert.isObject instance.toResponseObject().headers
      assert.strictEqual Object.keys(instance.toResponseObject().headers).length, 1
