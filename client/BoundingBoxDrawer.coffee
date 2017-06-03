class BoundingBoxDrawer

  constructor: (@canvas, @image) ->
    @context = @canvas.getContext '2d'

    @bbCallback = null
    @firstPoint = null
    @lastPoint = null
    @currentPoint = null

    @canvas.addEventListener 'mousemove', @_mouseMove
    @canvas.addEventListener 'mouseup', @_mouseUp
    @canvas.addEventListener 'mousedown', @_mouseDown

  setBbCallback: (@bbCallback) =>
    return

  clear: =>
    @firstPoint = null
    @lastPoint = null
    @_update()

  show: (boundingBox) =>
    xMin = (boundingBox.x * @image.clientWidth) + @image.offsetLeft
    yMin = (boundingBox.y * @image.clientHeight) + @image.offsetTop

    xMax = xMin + (boundingBox.width * @image.clientWidth)
    yMax = yMin + (boundingBox.height * @image.clientHeight)

    @firstPoint = {
      x: xMin
      y: yMin
    }

    @lastPoint = {
      x: xMax
      y: yMax
    }

    @_update()
    return

  _mouseMove: (event) =>
    @currentPoint = {
      x: event.clientX
      y: event.clientY
    }
    @_update()
    return

  _mouseDown: (event) =>
    if @firstPoint? and @lastPoint?
      @clear()
    @_mouseMove event

  _mouseUp: (event) =>
    point = {
      x: event.clientX
      y: event.clientY
    }

    unless @firstPoint?
      @firstPoint = point
      @_update()
      return

    @lastPoint = point
    @_emitBB()
    return

  _update: =>
    @context.clearRect 0, 0, @canvas.width, @canvas.height

    if @firstPoint?
      @_drawPoint(@firstPoint)
    if @lastPoint?
      @_drawPoint(@lastPoint)
    if @currentPoint?
      @_drawPoint(@currentPoint)

  _drawPoint: (point) ->
    @context.beginPath()
    @context.moveTo 0, point.y
    @context.lineTo @canvas.width, point.y
    @context.stroke()

    @context.beginPath()
    @context.moveTo point.x, 0
    @context.lineTo point.x, @canvas.height
    @context.stroke()

  _emitBB: =>
    firstPoint = @_normalizePoint @firstPoint
    lastPoint = @_normalizePoint @lastPoint

    x = Math.min lastPoint.x, firstPoint.x
    y = Math.min lastPoint.y, firstPoint.y
    width = Math.abs lastPoint.x - firstPoint.x
    height = Math.abs lastPoint.y - firstPoint.y

    if @bbCallback?
      @bbCallback {x, y, width, height}

  _normalizePoint: (inputPoint) =>
    point = {
      x: inputPoint.x
      y: inputPoint.y
    }

    point.x -= @image.offsetLeft
    point.y -= @image.offsetTop

    point.x /= @image.clientWidth
    point.y /= @image.clientHeight

    point.x = Math.max 0, Math.min 1, point.x
    point.y = Math.max 0, Math.min 1, point.y
    return point

module.exports = BoundingBoxDrawer