unirest = require 'unirest'

class ImageApiClient

  constructor: ->
    @images = []
    @currentImageIndex = 0

  load: =>
    return new Promise (resolve) =>
      unirest.get 'http://localhost:3000/images/'
        .end (images) =>
          @images = images.body
          resolve()

  getCurrentImage: =>
    id = @images[@currentImageIndex]

    return new Promise (resolve) ->
      unirest.get "http://localhost:3000/images/#{id}"
        .end (response) ->
          imageUrl = "http://localhost:3000/images/#{id}/file"
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

    return new Promise (resolve) ->
      unirest.patch "http://localhost:3000/images/#{id}"
        .send imageData
        .end (response) ->
          resolve response
    return

module.exports = ImageApiClient