ImageApi = require './ImageApi'

args = require('minimist')(process.argv.slice(2))
args.imagePath ?= './images'

express = require 'express'
app = express()

imageApi = new ImageApi(args.imagePath, app)
app.use express.static('public')

app.listen(3000)