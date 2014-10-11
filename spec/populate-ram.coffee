###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
Creates and populates RAM for video testing
---------|---------|---------|---------|---------|---------|---------|--
###
RAM_TILE = [
  parseInt '00011011' + '11100100', 2
  parseInt '11111111' + '11111111', 2
  parseInt '00000000' + '11111111', 2
  parseInt '01010101' + '11111111', 2
  parseInt '00000000' + '10101010', 2
  parseInt '00000000' + '00000000', 2
  parseInt '00000000' + '00000000', 2
  parseInt '11100100' + '00011011', 2
]

setRAM = (ram, startAddress, values) ->
  ram[startAddress...(startAddress + values.length)] = values

ljd.makeRAM = () ->
  Video = ljd.Video
  ram = (0 for _ in [0...(Math.pow(2, 16))])

  addressOfTile2 = Video.TILE_INDEX + (Video.TILE_INDEX_STEP * 2)
  ram[addressOfTile2...(addressOfTile2 + 8)] = RAM_TILE

  TILE_COLORS = Video.TILE_COLORS
  ram[TILE_COLORS...(TILE_COLORS + 4)] = [
    parseInt('00000' + '000000' + '00000', 2) # Black
    parseInt('11111' + '000000' + '00000', 2) # Red
    parseInt('00000' + '111111' + '00000', 2) # Green
    parseInt('00000' + '000000' + '11111', 2) # Blue
  ]
  SPRITE_COLORS = Video.SPRITE_COLORS
  ram[SPRITE_COLORS...(SPRITE_COLORS + 4)] = [
    parseInt('11111' + '111111' + '11111', 2) # White
    parseInt('00000' + '100000' + '10000', 2) # Cyan
    parseInt('10101' + '101011' + '00000', 2) # Yellow
    parseInt('10000' + '000000' + '10000', 2) # Magenta
  ]

  ram[Video.GRID_CELLS...(Video.GRID_CELLS + 8)] = [
    #gridCell:tileIndex;colorPair1;colorPair2
    parseInt('00000010' + '0001' + '0000', 2)
    parseInt('00000010' + '0001' + '0000', 2)
    parseInt('00000010' + '0001' + '0000', 2)
    parseInt('00000010' + '0001' + '0000', 2)
    parseInt('00000010' + '0000' + '0001', 2)
    parseInt('00000010' + '0000' + '0001', 2)
    parseInt('00000010' + '0000' + '0001', 2)
    parseInt('00000010' + '0000' + '0001', 2)
  ]
  ram[Video.GRID_CELLS + 2399] =
    #        tile # 255   cp1=15   cp2=10
    parseInt('11111111' + '1111' + '1010', 2)
  ram

ljd.RAM_TILE = RAM_TILE
