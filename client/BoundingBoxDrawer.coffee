class BoundingBoxDrawer

  constructor: (@canvas, @image, @bbCallback) ->
    @context = @canvas.getContext '2d'

    @firstPoint = null
    @lastPoint = null
    @currentPoint = null

    @canvas.addEventListener 'mousemove', @_mouseMove
    @canvas.addEventListener 'mouseup', @_mouseUp
    @canvas.addEventListener 'mousedown', @_mouseDown

  _mouseMove: (event) =>
    @currentPoint = {
      x: event.clientX
      y: event.clientY
    }
    @_update()
    return

  _mouseDown: =>
    if @firstPoint? and @lastPoint?
      @firstPoint = null
      @lastPoint = null
      @_update()

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