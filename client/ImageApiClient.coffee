unirest = require 'unirest'

class ImageApiClient

  constructor: ->
    @images = []
    @currentImageIndex = 0
    @label = null

  setLabel: (@label) =>
    @images = []
    @currentImageIndex = 0
    return

  load: =>
    return new Promise (resolve) =>
      unirest.get "http://localhost:3000/images/#{@label}/"
        .end (images) =>
          @images = images.body
          resolve()

  getCurrentImage: =>
    id = @images[@currentImageIndex]

    return new Promise (resolve) =>
      unirest.get "http://localhost:3000/images/#{@label}/#{id}"
        .end (response) =>
          imageUrl = "http://localhost:3000/images/#{@label}/#{id}/file"
          resolve {imageData: response.body, imageUrl}

  next: =>
    @currentImageIndex++

    if @currentImageIndex == @images.length
      @currentImageIndex--

    return @getCurrentImage()

  previous: =>
    @currentImageIndex--

    if @currentImageIndex == -1
      @currentImageIndex = 0

    return @getCurrentImage()

  setCurrentImage: (imageData) =>
    id = @images[@currentImageIndex]

    return new Promise (resolve) =>
      unirest.patch "http://localhost:3000/images/#{@label}/#{id}"
        .headers({'Accept': 'application/json', 'Content-Type': 'application/json'})
        .send imageData
        .end (response) ->
          resolve response
    return

module.exports = ImageApiClient