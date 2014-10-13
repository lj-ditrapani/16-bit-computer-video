###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
Main video specs requiring Video spec module set-up
---------|---------|---------|---------|---------|---------|---------|--
###

module 'Video',
  setup: ->
    @ram = ljd.makeRAM()
    context = new ljd.MockCanvasContext()
    @video = new ljd.Video(@ram, context, 4)
    @data = context.createImageData(480, 320).data

test '16-bit to 24-bit color conversion for all colors', ->
  @video.make24bitColors()
  cellColorPairs = [
    [[0, 0, 0],    [0xFF, 0, 0]]
    [[0, 0xFF, 0], [0, 0, 0xFF]]
  ]
  spriteColorPairs = [
    [[0xFF, 0xFF, 0xFF], [0, 130, 132]]
    [[173, 174, 0],      [132, 0, 132]]
  ]
  equal @video.cellColorPairs.length, 16
  equal @video.spriteColorPairs.length, 16
  deepEqual @video.cellColorPairs[0...2], cellColorPairs
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

test 'setSpriteColorsAndTiles', ->
  @video.updateData()
  sprites = @video.sprites
  tests = [
    # s#   color 0             color 3      tile[0][0]
    [  0, [173, 174, 0],      [0, 130, 132], 3]  # 1 0 Yellow Cyan
    [  4, [0xFF, 0xFF, 0xFF], [132, 0, 132], 1]  # 0 1 White Magenta
    [127, [0xFF, 0xFF, 0xFF], [0, 130, 132], 0]  # 0 0 White Cyan
  ]
  for [i, color0, color3, pixel00] in tests
    sprite = sprites[i]
    equal sprite.colors.length, 4, '4 colors'
    deepEqual sprite.colors[0], color0, 'Color 0 is correct'
    deepEqual sprite.colors[3], color3, 'Color 3 is correct'
    equal sprite.tile.array[0][0], pixel00, 'First pixel is correct'

test 'setGridSprites', ->
  @video.updateData()
  tests = [
    # tile cp1 cp2  XY xpos ypos
    [    3,  1,  0,  0,   4,   0]
    [    3,  1,  0,  2,   5,   0]
    [    3,  1,  0,  1,   6,   0]
    [    3,  1,  0,  3,   7,   0]
    [  255,  0,  1,  0,  59,  38]
    [  255,  0,  1,  0,  58,  39]
    [    5,  1,  1,  0,   0,   0]
  ]
  for [tile, cp1, cp2, xy, xPosition, yPosition] in tests
    cell = @video.grid[yPosition][xPosition]
    sprite = cell.sprite
    label = "Sprite @ (#{xPosition},#{yPosition})"
    deepEqual [sprite.tileIndex, sprite.colorPair1, sprite.colorPair2],
              [tile, cp1, cp2], label
    deepEqual [sprite.xyFlip, sprite.xPosition, sprite.yPosition],
              [xy, xPosition, yPosition], label
    equal sprite.sprite, false, label

test 'setGridColorsAndTiles', ->
  @video.updateData()
  grid = @video.grid
  tests = [
    # x,  y   color 0             color 3       tile[0][4]
    [ 0,  0, [0x00, 0xFF, 0x00], [0xFF, 0x00, 0x00], 3]  # 1 0 Gn Rd
    [ 8,  0, [0x00, 0x00, 0x00], [0x00, 0x00, 0xFF], 0]  # 0 1 Ba Bu
    [59, 39, [0x84, 0x86, 0x84], [0x00, 0x00, 0x00], 1]  # F A Gy Ba
  ]
  for [x, y, color0, color3, pixel04] in tests
    cell = grid[y][x]
    equal cell.colors.length, 4, '4 colors'
    deepEqual cell.colors[0], color0, 'Color 0 is correct'
    deepEqual cell.colors[3], color3, 'Color 3 is correct'
    equal cell.tile.array[0][4], pixel04, '4th pixel is correct'

test 'setGridXYFlip', ->
  @video.updateData()
  grid = @video.grid
  tests = [0, 2, 1, 3, 0, 0, 0, 0]
  for xyFlip, i in tests
    cell = grid[0][i]
    equal cell.xyFlip, xyFlip
