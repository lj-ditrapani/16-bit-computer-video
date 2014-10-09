###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
---------|---------|---------|---------|---------|---------|---------|--
###


# offset = 0xDB00 # 55,296

tileNumbers = (0 for _ in [0...64])


module 'Video',
  setup: ->
    @newScreen4x = ljd.Video.newScreen4x
    numElements = 480 * 320 * 4 * 4
    @offset = 10
    @ram = (0 for _ in [0...(1024 * 5 * @offset)])
    # first 4 pixels = [0, 1, 2, 3]
    # As a byte in base 2:  %00011011
    # As a byte in hex: 0x1B
    first8pixels = 0x1B << 8
    addressOf3rdTile = @offset + (8 * 2)
    @ram[addressOf3rdTile] = first8pixels
    addressOf2ndCell = @offset + 2048 + 1
    @ram[addressOf2ndCell] = 
    @data = (0 for _ in [0...numElements])


# ? R G B #
test 'background', ->
  @newScreen4x(@offset, @ram, @data)
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
  # pixels 1-3 of second cell in first row
  deepEqual @data[64..95], expectedColors
  ok false, @data[64..95].length/8


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
test 'sprite', ->
  @newScreen4x(@offset, @ram, @data)
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
