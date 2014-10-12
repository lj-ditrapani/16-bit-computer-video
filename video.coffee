###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
---------|---------|---------|---------|---------|---------|---------|--
For each row in grid
  for each cell in grid
    Perform any necessary flipping of tile data structure
    if a sprite exists on that cell
      get the sprite tile
      perform any necessary flipping of tile data structure
      get 4 24-bit sprite colors
    Write all 64 pixels (8x8) for cell into imagePixelData
###


if (typeof ljd).toString() == 'undefined'
  window.ljd = {}


class Tile
  
  constructor: (ramTile) ->
    # 8 rows of 8 2-bit (0-3) values
    @array = ramTile.map(Tile.word2row)

  # return a properly flipped array
  flip: (n) ->
    switch n
      when 0 then @array
      when 1 then Tile.flipY @array
      when 2 then Tile.flipX @array
      when 3 then Tile.flipY Tile.flipX(@array)
      else throw Error("n=#{n}; n must be between 0 and 3 inclusive")

Tile.word2row = (word) ->
  row = []
  for i in [0...8]
    row.unshift(word & 3)
    word = word >> 2
  row

Tile.flipX = (array) ->
  array.reverse()

Tile.flipY = (array) ->
  array.map((row) -> row.reverse())


###
Cell (same for both Tile and Sprite)
  constructor(ramCell)
  tile index: 0-255
  cp1: 0-15
  cp2: 0-15
  sprite:  false | sprite Cell
  xyFlip: 0-3
  --------Sprite only---------
  xPosition
  yPosition
  ----------------------------
  tile: Tile
  colors: 4-element array
  ----------------------------
  setSprite(spriteCell)
  setTile(@tiles)
  setColors(@tileColors or @spriteColors)
###
class Cell

  constructor: (ramCell) ->
    @tileIndex = ramCell >> 8
    @colorPair1 = (ramCell >> 4) & 0xF
    @colorPair2 = ramCell & 0xF
    @sprite = false

  setColors: (colorPairs) ->
    @colors = colorPairs[@colorPair1]
    @colors = @colors.concat(colorPairs[@colorPair2])

  setTile: (tiles) ->
    @tile = tiles[@tileIndex]

  setSprite: (spriteCell) ->
    if @sprite is false
      @sprite = spriteCell


makeSprite = (value0, value1) ->
  sprite = new Cell(value0)
  sprite.xyFlip = value1 >> 14
  sprite.xPosition = (value1 >> 8) & 0x3F
  sprite.yPosition = value1 & 0x3F
  sprite


class Video

  constructor: (@ram, @context, @zoom) ->
    @context.imageSmoothingEnabled = false
    @imageData = @context.createImageData(480, 320)
    @tiles = []
    @grid = []

  update: ->
    @updateData()
    @updateScreen()
    @context.putImageData(@imageData, 0, 0)

  # Update data structures with contents of RAM
  updateData: ->
    @make24bitColors()
    @makeTiles()
    @makeGrid()

    @makeSprites()
    @setSpriteColorsAndTiles()

    @setGridSprites()
    ###
    @setGridXYFlip()
    @setGridColors()
    @setGridTiles()
    ###

  # Update imageData based on new in data structures
  updateScreen: ->

  zoom: (amount) ->
    # amount is either 1 or 4

  # Creates two arrays of 16 color pairs
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

  makeTiles: ->
    @tiles = []
    for i in [0..255]
      startAddress = Video.TILE_INDEX + (i * 8)
      ramTile = @ram[startAddress...(startAddress + 8)]
      @tiles.push(new Tile(ramTile))

  makeGrid: ->
    makeRow = (ramCellRow) ->
      ramCellRow.map((ramCell) -> (new Cell(ramCell)))
    @grid = []
    for i in [0...40]
      startAddress = Video.GRID_CELLS + i * 60
      endAddress = Video.GRID_CELLS + i * 60 + 60 
      ramCellRow = @ram[startAddress...endAddress]
      row = makeRow ramCellRow
      @grid.push row

  makeSprites: ->
    @sprites = []
    for i in [0...128]
      address = Video.SPRITES + i * 2
      [value0, value1] = @ram[address..(address + 1)]
      @sprites.push makeSprite(value0, value1)

  setSpriteColorsAndTiles: ->
    for sprite in @sprites
      sprite.setColors(@spriteColorPairs)
      sprite.setTile(@tiles)

  # Must ensure if a sprite already exists on cell
  # do not replace with new one, keep old sprite
  # If recycling data structures, be sure to clear
  # all sprites at beginning
  setGridSprites: ->
    for sprite in @sprites
      cell = @grid[sprite.yPosition][sprite.xPosition]
      cell.setSprite(sprite)


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

Video.Tile = Tile
Video.Cell = Cell
ljd.Video = Video
