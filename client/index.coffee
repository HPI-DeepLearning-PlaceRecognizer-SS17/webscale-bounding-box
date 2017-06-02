BoundingBoxDrawer = require './BoundingBoxDrawer.coffee'

drawCanvas = document.getElementById 'drawCanvas'
drawCanvas.width = drawCanvas.clientWidth
drawCanvas.height = drawCanvas.clientHeight

labeledImage = document.getElementById 'labeledImage'

bbDrawer = new BoundingBoxDrawer(drawCanvas, labeledImage, (bbox) -> console.log bbox)


