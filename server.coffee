ImageApi = require './ImageApi'

args = require('minimist')(process.argv.slice(2))
args.imagePath ?= './images'

express = require 'express'
app = express()

app.use require('body-parser').json({limit: '2mb'})

imageApi = new ImageApi(args.imagePath, app)
app.use express.static('public')

app.listen(3000)