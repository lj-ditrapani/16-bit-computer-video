###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
Video specs that do not require Video spec module set-up
---------|---------|---------|---------|---------|---------|---------|--
###

test 'Single 16-bit color to 24-bit color conversion', ->
  inputs = [
    parseInt('00000' + '00000' + '00000', 2) # Black
    parseInt('11111' + '00000' + '00000', 2) # Red
    parseInt('00000' + '11111' + '00000', 2) # Green
    parseInt('00000' + '00000' + '11111', 2) # Blue
    parseInt('11111' + '11111' + '11111', 2) # White
    parseInt('00000' + '10000' + '10000', 2) # Cyan
    parseInt('10101' + '10101' + '00000', 2) # Yellow
    parseInt('10000' + '00000' + '10000', 2) # Magenta
  ]
  outputs = [
    [0, 0, 0]
    [0xFF, 0, 0]
    [0, 0xFF, 0]
    [0, 0, 0xFF]
    [0xFF, 0xFF, 0xFF]
    [0, 132, 132]
    [173, 173, 0]
    [132, 0, 132]
  ]
  for input, i in inputs
    output = outputs[i]
    deepEqual ljd.Video.to24bitColor(input), output


test 'Cell construction', ->
  ramCell = (2 << 8) + (1 << 4) + 0   # Tile # 2, cp1 = 1, cp2 = 0
  cell = new ljd.Video.Cell(ramCell)
  equal cell.tileIndex, 2
  equal cell.colorPair1, 1
  equal cell.colorPair2, 0
  equal cell.sprite, false


class ljd.MockCanvasContext

  constructor: () ->
    numElements = 480 * 320 * 4
    data = (0 for _ in [0...numElements])
    @imageData = {data: data}

  createImageData: (width, height) ->
    @imageData

  putImageData: (imageData, x, y) ->


test 'gridTile2ImageDataIndex', ->
  gridTile2ImageDataIndex = ljd.Video.gridTile2ImageDataIndex
  tests = [
    [  0,  0, 0,      0]
    [  0,  1, 0,     32]  # (8) * 4
    [  0,  0, 1,   1920]  # (480) * 4
    [  1,  0, 0,  15360]  # (480 * 8) * 4
    [  1,  0, 1,  17280]  # (480 * 8 + 480) * 4
    [  1,  1, 1,  17312]  # (480 * 8 + 480 + 8) * 4
    [  5,  4, 3,  82688]  # (480 * 8 * 5 + 480 * 3 + 8 * 4) * 4
    [ 39, 59, 7, 614368]  # (480 * 320 - 8) * 4
  ]
  # The equation is (480 * 8 * gridY + 480 * tileY + 8 * gridX) * 4
  for [gridY, gridX, tileY, pixelIndex] in tests
    equal gridTile2ImageDataIndex(gridY, gridX, tileY), pixelIndex
