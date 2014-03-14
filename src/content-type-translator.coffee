contentTypes =
  json: 'application/json'
  xml: 'application/xml'

translate = (type) ->
  key = type.toLowerCase()
  type = contentTypes[key] if contentTypes[key]?
  return type

module.exports = translate
