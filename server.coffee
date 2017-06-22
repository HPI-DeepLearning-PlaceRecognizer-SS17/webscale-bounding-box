ImageApi = require './ImageApi'
LabelApi = require './LabelApi'

args = require('minimist')(process.argv.slice(2))
args.imagePath ?= './images'

express = require 'express'

console.log 'Starting server'
app = express()
app.use require('body-parser').json {limit: '2mb'}
app.use require('morgan') 'dev'
app.use express.static('public')

console.log 'Discovering labels'
labelApi = new LabelApi(args.imagePath, app)
labels = labelApi.getLabels()
console.log 'Found labels: ' + JSON.stringify labels

for label in labels
  console.log "Initializing ImageAPI for '#{label}'"
  new ImageApi(args.imagePath, label, app)

console.log "Listening on port 3000"
app.listen(3000)