express = require('express')
app = express()
bodyParser = require('body-parser')
{handle} = require('./lib/handlers')

app.use bodyParser.json()

app.post '/payload', (request, response, next) ->
  name = request.headers['x-github-event']
  event = request.body
  handle name, event
  next()

app.use (request, response) ->
  response.send 'You are not supposed to be here.'
  response.end()

app.listen 4567, ->
  console.log 'Server started at http://localhost:4567'
