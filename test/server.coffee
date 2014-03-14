require 'coffee-errors'
express = require 'express'

PORT = '3333'

app = express()

app.post '/machines', (req, res) ->
  res.setHeader 'Content-Type', 'application/json'
  res.setHeader 'Content-Encoding', 'none'
  response =
    message: "Accepted"
  res.send 202, response

app.get '/machines', (req, res) ->
  res.setHeader 'Content-Type', 'application/json'
  res.setHeader 'Content-Encoding', 'none'
  machine =
    _id: '52341870ed55224b15ff07ef'
    type: 'bulldozer'
    name: 'willy'
  response = [machine]
  res.send 200, response

server = app.listen PORT
