BoundingBoxDrawer = require './BoundingBoxDrawer.coffee'
ImageApiClient = require './ImageApiClient.coffee'

drawCanvas = document.getElementById 'drawCanvas'
drawCanvas.width = drawCanvas.clientWidth
drawCanvas.height = drawCanvas.clientHeight

labeledImage = document.getElementById 'labeledImage'

appState = {
  busy: true
  currentImage: null
  currentImageUrl: null
  label: null
}

angular = require 'angular'
require 'angular-resource'
app = angular.module 'webscaleBoundingBox', ['ngResource']
require './menuController.coffee'
require './Label.coffee'

bbDrawer = new BoundingBoxDrawer(drawCanvas, labeledImage, (bbox) -> console.log bbox)
apiClient = new ImageApiClient()

updateGui = ->
  imageReadyPromise = new Promise (resolve) ->
    labeledImage.onload = ->
      bbDrawer.clear()
      if appState.currentImage.boundingBox
        bbDrawer.show appState.currentImage.boundingBox
      resolve()
      return

  labeledImage.src = appState.currentImageUrl
  return imageReadyPromise

handleLoadedImage = ({imageData, imageUrl}) ->
  appState.currentImage = imageData
  appState.currentImageUrl = imageUrl
  return updateGui().then -> appState.busy = false

bbDrawer.setBbCallback (bbox) =>
  return if appState.busy
  appState.busy = true

  image = appState.currentImage
  image.boundingBox = bbox
  image.annotationStatus = 'manuallyAnnotated'

  apiClient.setCurrentImage(image)
    .then -> apiClient.next()
    .then handleLoadedImage

  return

init = ->
  apiClient.load()
    .then -> apiClient.getCurrentImage()
    .then handleLoadedImage
  return

init()

# Binding between angular and legacy code
app.controller 'mainController', ($scope) ->
  $scope.$on 'activeLabelChange', (event, newActiveLabel) ->
    console.log newActiveLabel
    appState.label = newActiveLabel
    apiClient.setLabel(newActiveLabel)
    init()
  return

document.addEventListener 'keyup', (event) ->
  return if appState.busy

  key = event.key
  console.log key

  switch key
    when 'ArrowRight'
      appState.busy = true
      apiClient.next()
        .then handleLoadedImage

    when 'ArrowLeft'
      appState.busy = true
      apiClient.previous()
        .then handleLoadedImage

    when 'n'
      appState.busy = true
      image = appState.currentImage
      image.annotationStatus = 'ignore'
      delete image.boundingBox

      apiClient.setCurrentImage(image)
      .then -> apiClient.next()
      .then handleLoadedImage
  return