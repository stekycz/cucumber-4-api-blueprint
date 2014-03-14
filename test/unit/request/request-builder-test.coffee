require 'coffee-errors'
{assert} = require 'chai'

RequestBuilder = require '../../../src/request/request-builder'

describe 'RequestBuilder', () ->
  instance = null
  beforeEach () ->
    instance = new RequestBuilder 'http://localhost', '3333'

  describe 'constructor', () ->
    it 'should create new instance', () ->
      assert.isObject instance
      assert.instanceOf instance, RequestBuilder

    it 'should create empty request', () ->
      assert.isNull instance.method
      assert.isNull instance.uriTemplate
      assert.strictEqual instance.body, ''
      assert.isObject instance.headers
      assert.equal Object.keys(instance.headers).length, 0
      assert.isObject instance.parameters
      assert.equal Object.keys(instance.parameters).length, 0

  describe 'setMethod', () ->
    it 'should set method property', () ->
      instance.setMethod 'GET'
      assert.strictEqual instance.method, 'GET'

  describe 'setUriTemplate', () ->
    it 'should set URI template property', () ->
      instance.setUriTemplate '/api/v1/gists'
      assert.strictEqual instance.uriTemplate, '/api/v1/gists'

  describe 'setBody', () ->
    it 'should set body property', () ->
      instance.setBody '{ "message": "Accepted" }'
      assert.strictEqual instance.body, '{ "message": "Accepted" }'

  describe 'setParameter', () ->
    it 'should set parameter by given name', () ->
      instance.setParameter 'title', 'Gist title'
      assert.isObject instance.parameters
      assert.propertyVal instance.parameters, 'title', 'Gist title'

    it 'should be case sensitive', () ->
      instance.setParameter 'title', 'Gist title'
      instance.setParameter 'Title', 'Gist title'
      assert.isObject instance.parameters
      assert.propertyVal instance.parameters, 'title', 'Gist title'
      assert.propertyVal instance.parameters, 'Title', 'Gist title'

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
