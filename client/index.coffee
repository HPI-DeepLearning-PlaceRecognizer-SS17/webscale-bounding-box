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
  labeledImage.src = appState.currentImageUrl
  # ToDo read out bb and display

apiClient.load()
  .then -> apiClient.getCurrentImage()
  .then ({imageData, imageUrl}) ->
    appState.currentImage = imageData
    appState.currentImageUrl = imageUrl
    appState.busy = false
    updateGui()

document.addEventListener 'keyup', (event) ->
  return if appState.busy

  key = event.key
  console.log key

  switch key
    when 'ArrowRight'
      appState.busy = true
      apiClient.next()
        .then ({imageData, imageUrl}) ->
          appState.currentImage = imageData
          appState.currentImageUrl = imageUrl
          appState.busy = false
          updateGui()

    when 'ArrowLeft'
      appState.busy = true
      apiClient.previous()
        .then ({imageData, imageUrl}) ->
        appState.currentImage = imageData
        appState.currentImageUrl = imageUrl
        appState.busy = false
        updateGui()

    when 'n'
      appState.busy = true
      image = appState.currentImage
      image.manualAnnotation ?= {}
      image.manualAnnotation.hasBoundingBox = false

      apiClient.setCurrentImage(image)
      .then -> apiClient.next()
      .then ({imageData, imageUrl}) ->
          appState.currentImage = imageData
          appState.currentImageUrl = imageUrl
          appState.busy = false
          updateGui()
  return