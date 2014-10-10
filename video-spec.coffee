###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
---------|---------|---------|---------|---------|---------|---------|--
###


# offset = 0xDB00 # 55,296

tileNumbers = (0 for _ in [0...64])


class MockCanvasContext

  constructor: (@imageData) ->

  createImageData: (width, height) ->
    @imageData

  putImageData: (imageData, x, y) ->


module 'Video',
  setup: ->
    Video = ljd.Video
    @ram = (0 for _ in [0...(Math.pow(2, 16))])

    # Tile pixels:
    # first 4 pixels = [0, 1, 2, 3]
    # As a byte in base 2:  %00011011
    # As a byte in hex: 0x1B
    first8pixels = 0x1B << 8
    addressOf3rdTile = Video.TILE_INDEX + (Video.TILE_INDEX_STEP * 2)
    @ram[addressOf3rdTile] = first8pixels

    TILE_COLORS = Video.TILE_COLORS
    @ram[TILE_COLORS...(TILE_COLORS + 4)] = [
      parseInt('00000' + '000000' + '00000', 2) # Black
      parseInt('11111' + '000000' + '00000', 2) # Red
      parseInt('00000' + '111111' + '00000', 2) # Green
      parseInt('00000' + '000000' + '11111', 2) # Blue
    ]
    SPRITE_COLORS = Video.SPRITE_COLORS
    @ram[SPRITE_COLORS...(SPRITE_COLORS + 4)] = [
      parseInt('11111' + '111111' + '11111', 2) # White
      parseInt('00000' + '100000' + '10000', 2) # Cyan
      parseInt('10101' + '101011' + '00000', 2) # Yellow
      parseInt('10000' + '000000' + '10000', 2) # Magenta
    ]

    addressOf2ndCell = Video.GRID_CELLS + 1
    # grid cell:  8-bit tile index; 4-bit color pair1; 4-bit color pair2
    @ram[addressOf2ndCell] = parseInt('00000010' + '0001' + '0000', 2)
    numElements = 480 * 320 * 4 * 4
    @data = (0 for _ in [0...numElements])
    context = new MockCanvasContext({data: @data})
    @video = new Video(@ram, context, 4)

test 'Singel 16-bit color to 24-bit color conversion', ->
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

test '16-bit to 24-bit color conversion for all colors', ->
  @video.make24bitColors(@ram)
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
