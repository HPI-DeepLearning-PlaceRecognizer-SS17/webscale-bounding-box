path = require 'path'
glob = require 'glob'
fs = require 'fs'

class ImageApi

	constructor: (@folder, @labelName, @app) ->
		@folder = path.normalize @folder
		@images = @_discoverImages @folder, @labelName
		@indexJson = @_updateIndexFile(@folder, @labelName, @images)

		@app.get "/images/#{@labelName}", @_getImages
		@app.get "/images/#{@labelName}/:imageId/file", @_getImageFile
		@app.get "/images/#{@labelName}/:imageId", @_getImage
		@app.patch "/images/#{@labelName}/:imageId", @_patchImage
		return

	# Creates a list of all images that belong to the given label
	# (folder structure needs to be /.../folder/labelName/imageId.jpg)
	_discoverImages: (folder, labelName) =>
		imageFolder = path.join folder, labelName

		images = glob.sync '*.jpg', {cwd: imageFolder}
		images = images.sort()

		images = images.map (imageFile) ->
			imageIdOnly = imageFile.substr(0, imageFile.length - 6)

			return {
				id: imageIdOnly
				pictureFile: imageFile
				jsonFile: imageIdOnly + '.json'
			}

		return images

	# Given the discovered images, updates the folder/labelName.json index file with data from all individual files
	_updateIndexFile: (folder, label, images) ->
		# First, load all images
		images = images.map (image) ->
			jsonContent = fs.readFileSync path.join(folder, label, image.jsonFile), {encoding: 'utf8'}
			imageJson = JSON.parse jsonContent
			return imageJson

		# Then, load the index file if it exists
		indexJson = {}
		jsonPath = path.join folder, label + '.json'
		if fs.existsSync jsonPath
			indexJsonContent = fs.readFileSync jsonPath, {encoding: 'utf8'}
			indexJson = JSON.parse indexJsonContent

		# Merge data - prefer information from individual jsons over the merged file
		# (but do not delete surplus data)
		for image in images
			indexJson[image.id] ?= {}
			indexJson[image.id].annotationStatus = image.annotationStatus
			indexJson[image.id].id = image.id

		fs.writeFileSync jsonPath, JSON.stringify(indexJson, true, 2)
		return indexJson

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

		jsonPath = path.join @folder, @label, imageEntry.jsonFile

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

		imagePath = path.resolve path.join @folder, @label, imageEntry.pictureFile
		response.sendFile imagePath
		return

	_patchImage: (request, response) =>
		imageEntry = @_getImageEntry request.params.imageId

		if not imageEntry?
			response.status(404).end()
			return

		imageData = request.body

		jsonPath = path.join @folder, @label, imageEntry.jsonFile
		jsonString = JSON.stringify imageData, true, 2

		fs.writeFile jsonPath, jsonString, 'utf8', (error) ->
			if error?
				response.status(500).json(error)
			else
				response.status(200).end()
			return

		@_updateIndexFile @folder, @label, [imageData]
		return

module.exports = ImageApi