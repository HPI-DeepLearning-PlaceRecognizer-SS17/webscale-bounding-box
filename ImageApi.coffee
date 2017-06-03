path = require 'path'
glob = require 'glob'
fs = require 'fs'

class ImageApi

	constructor: (@folder, @app) ->
		@folder = path.normalize @folder
		@images = @_discoverImages @folder

		@app.get '/images/', @_getImages
		@app.get '/images/:imageId/file', @_getImageFile
		@app.get '/images/:imageId', @_getImage
		@app.patch '/images/:imageId', @_patchImage
		return

	_discoverImages: (folder) =>
		images = glob.sync '*.jpg', {cwd: folder}
		images = images.sort()

		images = images.map (imageFile) ->
			imageIdOnly = imageFile.substr(0, imageFile.length - 6)

			return {
				id: imageIdOnly
				pictureFile: imageFile
				jsonFile: imageIdOnly + '.json'
			}

		return images

	_getImageEntry: (id) =>
		for image in @images
			if image.id is id
				return image
		return null

	_getImages: (request, response) =>
		response.json @images.map (image) -> image.id
		return

	_getImage: (request, response) =>
		imageEntry = @_getImageEntry request.params.imageId

		if not imageEntry?
			response.status(404).end()
			return

		jsonPath = path.join @folder, imageEntry.jsonFile

		fs.readFile jsonPath, 'utf8', (error, data) ->
			unless error?
				response.json JSON.parse data
			else
				response.status(500).json(error)
		return

	_getImageFile: (request, response) =>
		imageEntry = @_getImageEntry request.params.imageId

		if not imageEntry?
			response.status(404).end()
			return

		imagePath = path.resolve path.join @folder, imageEntry.pictureFile
		response.sendFile imagePath
		return

	_patchImage: (request, response) =>
		imageEntry = @_getImageEntry request.params.imageId

		if not imageEntry?
			response.status(404).end()
			return

		jsonPath = path.join @folder, imageEntry.jsonFile
		jsonString = JSON.stringify request.body, true, 2

		fs.writeFile jsonPath, jsonString, 'utf8', (error) ->
			if error?
				response.status(500).json(error)
			else
				response.status(200).end()
			return

		return

module.exports = ImageApi