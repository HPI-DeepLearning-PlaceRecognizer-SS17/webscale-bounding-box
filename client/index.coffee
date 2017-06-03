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
}

bbDrawer = new BoundingBoxDrawer(drawCanvas, labeledImage, (bbox) -> console.log bbox)
apiClient = new ImageApiClient()

updateGui = ->
  imageReadyPromise = new Promise (resolve) ->
    labeledImage.onload = ->
      bbDrawer.clear()
      if appState.currentImage.manualAnnotation?.bbox?
        bbDrawer.show appState.currentImage.manualAnnotation.bbox
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
  image.manualAnnotation ?= {}
  image.manualAnnotation.hasBoundingBox = true
  image.manualAnnotation.bbox = bbox

  apiClient.setCurrentImage(image)
    .then -> apiClient.next()
    .then handleLoadedImage

  return

apiClient.load()
  .then -> apiClient.getCurrentImage()
  .then handleLoadedImage

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
      image.manualAnnotation ?= {}
      delete image.manualAnnotation.bbox
      image.manualAnnotation.hasBoundingBox = false

      apiClient.setCurrentImage(image)
      .then -> apiClient.next()
      .then handleLoadedImage
  return