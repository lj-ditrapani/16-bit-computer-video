###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
---------|---------|---------|---------|---------|---------|---------|--
Convert the 64 16-bit colors to 24-bit colors
Create convenient data structures from video RAM
  - List of tiles
  - tile & sprite grid cells -> 60 x 40 matrix of Cells
  - List of sprites
Create sprite grid map (like grid cell data structure,
but false means no sprite)
For each row in grid
  for each cell in grid
    Convert cell (word) -> [index, cp1, cp2]
    get the tile
    convert tile to 8x8 matrix of 2-bit numbers
    get cell X Y flip data
    Perform any necessary flipping of tile data structure
    get the 4 24-bit tile colors
    if a sprite exists on that cell
      get the first sprite in list
      get the sprite tile
      convert tile to 8x8 matrix
      do any flipping
      get 4 24-bit sprite colors
    Write all 64 pixels (8x8) for cell into imagePixelData

Tile
  8 rows of 8 2-bit (0-3) values
  flip(X, Y) -> return new tile with proper flipping
                or same tile if (x, y) = (0, 0)

Cell (same for both Tile and Sprite)
  tile index
  cp1
  cp2
  X flip
  Y flip
  sprite:  false | sprite Cell

Grid
  60x40 Cells

Color pairs
  16 pairs of 24-bit colors

###


if (typeof ljd).toString() == 'undefined'
  window.ljd = {}


class Video

  constructor: (@ram, @context, @zoom) ->
    @context.imageSmoothingEnabled = false
    @imageData = @context.createImageData(480, 320)
    @tiles = []
    @grid = []
    @tileColorPairs = []
    @spriteColorPairs = []

  update: ->
    newScreen4x @offset, @ram, @imageData.data
    @context.putImageData(@imageData, 0, 0)

  zoom: (amount) ->
    # amount is either 1 or 4

  # returns two arrays of 16 color pairs
  # They are the 24-bit versions of the 16-bit tile color pairs and 
  # sprite color pairs in video RAM.
  make24bitColors: () ->
    [@tileColorPairs, @spriteColorPairs] = [[], []]
    @_make24bitColors 'tile'
    @_make24bitColors 'sprite'

  _make24bitColors: (colorSet) ->
    [address, array] = {
      tile: [Video.TILE_COLORS, @tileColorPairs]
      sprite: [Video.SPRITE_COLORS, @spriteColorPairs]
    }[colorSet]
    for i in [0...16]
      c16a = @ram[address + i * 2]
      c16b = @ram[address + i * 2 + 1]
      array.push([Video.to24bitColor(c16a), Video.to24bitColor(c16b)])

  # Modifies data to produce the new screen data (for 4x zoom)
  newScreen4x: () ->

Video.to24bitColor = (color) ->
  r16 = color >> 11
  g16 = (color >> 5) & 0x3F  # 11_1111
  b16 = color & 0x1F         #  1_1111
  r24 = (r16 << 3) | (r16 >> 2)
  g24 = (g16 << 2) | (g16 >> 4)
  b24 = (b16 << 3) | (b16 >> 2)
  [r24, g24, b24]

# RAM addresses for beginning of each video segment
Video.TILE_INDEX = 0xEC00
Video.GRID_CELLS = 0xF400
Video.CELL_X_Y_FLIP = 0xFD60
Video.SPRITES = 0xFE8C
Video.TILE_COLORS = 0xFF8C
Video.SPRITE_COLORS = 0xFFAC
# Number of words for each entry of a particular segment
Video.TILE_INDEX_STEP = 8   # 8 words per tile
Video.GRID_CELL_STEP = 1    # 1 word per cell
Video.SPRITE_STEP = 2       # 2 words per sprite data

ljd.Video = Video
