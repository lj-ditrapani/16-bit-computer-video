module 'Tile',
  setup: ->
    @array = [
      [0, 1, 2, 3, 3, 2, 1, 0]
      [3, 3, 3, 3, 3, 3, 3, 3]
      [0, 0, 0, 0, 3, 3, 3, 3]
      [1, 1, 1, 1, 3, 3, 3, 3]
      [0, 0, 0, 0, 2, 2, 2, 2]
      [0, 0, 0, 0, 0, 0, 0, 0]
      [0, 0, 0, 0, 0, 0, 0, 0]
      [3, 2, 1, 0, 0, 1, 2, 3]
    ]
    @tile = new ljd.Video.Tile(ljd.RAM_TILE)

test 'construction', ->
  deepEqual @tile.array, @array

test 'flip about NO axies', ->
  actualArray = @tile.flip(0) # %00 base 2
  deepEqual actualArray, @array

test 'flip about X axis', ->
  expectedArray = [
    [3, 2, 1, 0, 0, 1, 2, 3]
    [0, 0, 0, 0, 0, 0, 0, 0]
    [0, 0, 0, 0, 0, 0, 0, 0]
    [0, 0, 0, 0, 2, 2, 2, 2]
    [1, 1, 1, 1, 3, 3, 3, 3]
    [0, 0, 0, 0, 3, 3, 3, 3]
    [3, 3, 3, 3, 3, 3, 3, 3]
    [0, 1, 2, 3, 3, 2, 1, 0]
  ]
  actualArray = @tile.flip(2) # %10 base 2
  deepEqual actualArray, expectedArray

test 'flip about Y axis', ->
  expectedArray = [
    [0, 1, 2, 3, 3, 2, 1, 0]
    [3, 3, 3, 3, 3, 3, 3, 3]
    [3, 3, 3, 3, 0, 0, 0, 0]
    [3, 3, 3, 3, 1, 1, 1, 1]
    [2, 2, 2, 2, 0, 0, 0, 0]
    [0, 0, 0, 0, 0, 0, 0, 0]
    [0, 0, 0, 0, 0, 0, 0, 0]
    [3, 2, 1, 0, 0, 1, 2, 3]
  ]
  actualArray = @tile.flip(1) # %01 base 2
  deepEqual actualArray, expectedArray

test 'flip about X and Y axies', ->
  expectedArray = [
    [3, 2, 1, 0, 0, 1, 2, 3]
    [0, 0, 0, 0, 0, 0, 0, 0]
    [0, 0, 0, 0, 0, 0, 0, 0]
    [2, 2, 2, 2, 0, 0, 0, 0]
    [3, 3, 3, 3, 1, 1, 1, 1]
    [3, 3, 3, 3, 0, 0, 0, 0]
    [3, 3, 3, 3, 3, 3, 3, 3]
    [0, 1, 2, 3, 3, 2, 1, 0]
  ]
  actualArray = @tile.flip(3) # %11 base 2
  deepEqual actualArray, expectedArray

test 'Bad input', ->
  throws (-> @tile.flip(4)), /n=4; n must be between 0 and 3 inclusive/
