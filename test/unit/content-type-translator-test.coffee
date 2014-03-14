require 'coffee-errors'
{assert} = require 'chai'

translate = require '../../src/content-type-translator'

describe 'content type translation', () ->
  describe 'translate JSON', () ->
    it 'should return application/json', () ->
      assert.equal translate('json'), 'application/json'

    it 'should be case insensitive', () ->
      assert.equal translate('JSON'), 'application/json'

  describe 'translate XML', () ->
    it 'should return application/xml', () ->
      assert.equal translate('xml'), 'application/xml'

    it 'should be case insensitive', () ->
      assert.equal translate('XML'), 'application/xml'

  describe 'translate other', () ->
    it 'should return given type', () ->
      assert.equal translate('text/plain'), 'text/plain'

    it 'should not change letter case', () ->
      assert.equal translate('text/HTML'), 'text/HTML'

    it 'should return every unknown type', () ->
      assert.equal translate('quick brown fox jumps over lazy dog'), 'quick brown fox jumps over lazy dog'
