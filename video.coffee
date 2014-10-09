###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
---------|---------|---------|---------|---------|---------|---------|--
###


if (typeof ljd).toString() == 'undefined'
  window.ljd = {}


# Modifies data to produce the new screen data (for 4x zoom)
newScreen4x = (offset, ram, data) ->


class Video

  constructor: (@offset, @ram, @context, @zoom) ->
    width = element.width
    height = element.height
    @imageData = @context.createImageData(width, height)

  update: ->
    newScreen4x @offset, @ram, @imageData
    @context.putImageData(@imageData, 0, 0)

  zoom: (amount) ->
    # amount is either 1 or 4


Video.newScreen4x = newScreen4x
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
