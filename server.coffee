ImageApi = require './ImageApi'
LabelApi = require './LabelApi'

args = require('minimist')(process.argv.slice(2))
args.imagePath ?= './images'

express = require 'express'
app = express()

app.use require('body-parser').json({limit: '2mb'})

labelApi = new LabelApi(args.imagePath, app)
labels = labelApi.getLabels()

for label in labels
  new ImageApi(args.imagePath, label, app)

app.use express.static('public')

app.listen(3000)