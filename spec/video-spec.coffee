###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
---------|---------|---------|---------|---------|---------|---------|--
###

test 'Single 16-bit color to 24-bit color conversion', ->
  inputs = [
    parseInt('00000' + '000000' + '00000', 2) # Black
    parseInt('11111' + '000000' + '00000', 2) # Red
    parseInt('00000' + '111111' + '00000', 2) # Green
    parseInt('00000' + '000000' + '11111', 2) # Blue
    parseInt('11111' + '111111' + '11111', 2) # White
    parseInt('00000' + '100000' + '10000', 2) # Cyan
    parseInt('10101' + '101011' + '00000', 2) # Yellow
    parseInt('10000' + '000000' + '10000', 2) # Magenta
  ]
  outputs = [
    [0, 0, 0]
    [0xFF, 0, 0]
    [0, 0xFF, 0]
    [0, 0, 0xFF]
    [0xFF, 0xFF, 0xFF]
    [0, 130, 132]
    [173, 174, 0]
    [132, 0, 132]
  ]
  for input, i in inputs
    output = outputs[i]
    deepEqual ljd.Video.to24bitColor(input), output


module 'Cell',
  setup: ->

test 'construction', ->
  ramCell = (2 << 8) + (1 << 4) + 0   # Tile # 2, cp1 = 1, cp2 = 0
  cell = new ljd.Video.Cell(ramCell)
  equal cell.tileIndex, 2
  equal cell.colorPair1, 1
  equal cell.colorPair2, 0
  equal cell.sprite, false


class MockCanvasContext

  constructor: (@imageData) ->

  createImageData: (width, height) ->
    @imageData

  putImageData: (imageData, x, y) ->


module 'Video',
  setup: ->
    Video = ljd.Video
    @ram = ljd.makeRAM()
    numElements = 480 * 320 * 4 * 4
    @data = (0 for _ in [0...numElements])
    context = new MockCanvasContext({data: @data})
    @video = new Video(@ram, context, 4)

test '16-bit to 24-bit color conversion for all colors', ->
  @video.make24bitColors()
  tileColorPairs = [
    [[0, 0, 0],    [0xFF, 0, 0]]
    [[0, 0xFF, 0], [0, 0, 0xFF]]
  ]
  spriteColorPairs = [
    [[0xFF, 0xFF, 0xFF], [0, 130, 132]]
    [[173, 174, 0],      [132, 0, 132]]
  ]
  equal @video.tileColorPairs.length, 16
  equal @video.spriteColorPairs.length, 16
  deepEqual @video.tileColorPairs[0...2], tileColorPairs
  deepEqual @video.spriteColorPairs[0...2], spriteColorPairs

test 'makeTiles', ->
  @video.makeTiles()
  equal @video.tiles.length, 256
  tile2 = @video.tiles[2]
  equal tile2.array.length, 8
  equal tile2.array[7].length, 8
  deepEqual tile2.array[0], [0, 1, 2, 3, 3, 2, 1, 0]

test 'makeGrid', ->
  @video.makeGrid()
  grid = @video.grid
  [row0, row39] = [grid[0], grid[39]]
  equal grid.length, 40, '40 rows'
  deepEqual [row0.length, row39.length], [60, 60], '60 columns'
  tests = [
    [row0[0], 2, 1, 0]
    [row0[7], 2, 0, 1]
    [row39[59], 255, 15, 10]
  ]
  for [cell, tileIndex, cp1, cp2] in tests
    deepEqual [cell.tileIndex, cell.colorPair1, cell.colorPair2],
              [tileIndex, cp1, cp2],
              'Check individual cells'

test 'makeSprites', ->
  @video.makeSprites()
  sprites = @video.sprites
  equal sprites.length, 128, '128 sprites'
  tests = [
    #  #   tile cp1 cp2  XY xpos ypos
    [  0,    3,  1,  0,  0,   4,   0]
    [  1,    3,  1,  0,  2,   5,   0]
    [  2,    3,  1,  0,  1,   6,   0]
    [  3,    3,  1,  0,  3,   7,   0]
    [  4,  255,  0,  1,  0,  59,  38]
    [  5,  255,  0,  1,  0,  58,  39]
    [127,    0,  0,  0,  0,   0,   0]
  ]
  for [i, tile, cp1, cp2, xy, xpos, ypos] in tests
    label = "Sprite #{i}"
    sprite = sprites[i]
    deepEqual [sprite.tileIndex, sprite.colorPair1, sprite.colorPair2],
              [tile, cp1, cp2], label
    deepEqual [sprite.xyFlip, sprite.xPosition, sprite.yPosition],
              [xy, xpos, ypos], label
    equal sprite.sprite, false, label


###
# ? R G B #
test 'background', ->
  @video.newScreen4x()
  expectedColors = [
    #R     G     B     A
    0x00, 0x00, 0x00, 0xFF
    0x00, 0x00, 0x00, 0xFF
    0xFF, 0x00, 0x00, 0xFF
    0xFF, 0x00, 0x00, 0xFF
    0x00, 0xFF, 0x00, 0xFF
    0x00, 0xFF, 0x00, 0xFF
    0x00, 0x00, 0xFF, 0xFF
    0x00, 0x00, 0xFF, 0xFF
  ]
  # first 4 pixels (0-3) of second cell in first row
  deepEqual @data[64..95], expectedColors
###


###
# 16-bit Sprite color
#  R         G       B
# %10101   %101011  %00000
#
# 24-bit Sprite color
#  R           G          B
# %10101101   %10101110  %0000000
#  173         174        0
# $AD         $AE        $00
# The 2nd and 3rd pixels are from the background tile
# The 4th pixel is from the sprite
# ? B B S #
# ? R G Y #
# Red and green come from background
# Yello comes from sprite
###
###
test 'sprite', ->
  @video.newScreen4x()
  expectedColors = [
    #R     G     B     A
    0xFF, 0x00, 0x00, 0xFF
    0xFF, 0x00, 0x00, 0xFF
    0x00, 0xFF, 0x00, 0xFF
    0x00, 0xFF, 0x00, 0xFF
    0xAD, 0xAE, 0x00, 0xFF
    0xAD, 0xAE, 0x00, 0xFF
  ]
  deepEqual @data[8..31], expectedColors
  ok false, @data[8..31].length/8
  @ram[5..8] = [1, 2, 3, 4]
  ok false, @ram[5..9]
###
