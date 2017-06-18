unirest = require 'unirest'

class ImageApiClient

  constructor: ->
    @images = []
    @currentImageIndex = 0
    @label = null
    @filter = null

  setFilter: (@filter) =>
    return

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
    return @_getImage @currentImageIndex

  _getImage: (index) =>
    id = @images[index]

    return new Promise (resolve) =>
      unirest.get "http://localhost:3000/images/#{@label}/#{id}"
        .end (response) =>
          imageUrl = "http://localhost:3000/images/#{@label}/#{id}/file"
          resolve {imageData: response.body, imageUrl}

  next: =>
    console.log 'Choosing next image'
    nextImageIndex = @currentImageIndex + 1

    return @_checkImage nextImageIndex, 1
    .then (nextGoodIndex) =>
      if not nextGoodIndex?
        return @getCurrentImage()
      else
        @currentImageIndex = nextGoodIndex
        return @getCurrentImage()

  _checkImage: (index, direction) =>
    if index is @images.length or index is -1
      return Promise.resolve null
    return @_getImage(index)
      .then (image) =>
        if @_filterImage(image.imageData)
          return index
        else
          return @_checkImage index + direction, direction

  _filterImage: (imageData) =>
    if not @filter?
      return true

    if @filter.ignoredImages and imageData.annotationStatus is 'ignore'
      return false

    if @filter.goodBoundingBoxes and imageData.annotationStatus is 'manuallyAnnotated'
      return false

    if @filter.goodBoundingBoxes and imageData.annotationStatus is 'autoAnnotated-Good'
      return false

    if @filter.okayishBoundingBoxes and imageData.annotationStatus is 'autoAnnotated-NeedsImprovement'
      return false

    if @filter.okayishBoundingBoxes and imageData.annotationStatus is 'autoAnnotated'
      return false

    if @filter.unprocessedImages and imageData.annotationStatus is 'none'
      return false

    return true

  previous: =>
    previousImageIndex = @currentImageIndex - 1

    return @_checkImage previousImageIndex, -1
      .then (nextGoodIndex) =>
        if not nextGoodIndex?
          return @getCurrentImage()
        else
          @currentImageIndex = nextGoodIndex
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