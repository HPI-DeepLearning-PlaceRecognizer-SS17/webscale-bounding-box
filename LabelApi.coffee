fs = require 'fs'
path = require 'path'

class LabelApi

  constructor: (@folder, @app) ->
    @folder = path.normalize @folder
    @labels = @_discoverLabels(@folder)

    @app.get '/labels', @_getLabels
    return

  getLabels: => @labels

  _discoverLabels: (folder) ->
    files = fs.readdirSync(folder)
    subfolders = files.filter (file) ->
      return fs.lstatSync(path.join(folder,file)).isDirectory()
    return subfolders

  _getLabels: (request, response) =>
    response.json(@labels)
    return

module.exports = LabelApi