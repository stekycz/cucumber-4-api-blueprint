require 'coffee-errors'
{assert} = require 'chai'

translate = require '../../src/status-code-translator'

describe 'status code translation', () ->
  describe 'translate ok', () ->
    it 'should return 200', () ->
      assert.strictEqual translate('ok'), 200

    it 'should be case insensitive', () ->
      assert.strictEqual translate('OK'), 200

  describe 'translate not found', () ->
    it 'should return 404', () ->
      assert.strictEqual translate('not found'), 404

    it 'should be case insensitive', () ->
      assert.strictEqual translate('Not Found'), 404

  describe 'translate internal server error', () ->
    it 'should return 500', () ->
      assert.strictEqual translate('internal server error'), 500

    it 'should be case insensitive', () ->
      assert.strictEqual translate('Internal Server Error'), 500

  describe 'translate other', () ->
    it 'should return given code', () ->
      assert.strictEqual translate('unknown code'), 'unknown code'

    it 'should not change letter case', () ->
      assert.strictEqual translate('Unknown Code'), 'Unknown Code'

    it 'should return every unknown type', () ->
      assert.strictEqual translate('quick brown fox jumps over lazy dog'), 'quick brown fox jumps over lazy dog'
