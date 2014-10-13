###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
Tests that involve writing to Canvas ImageData
---------|---------|---------|---------|---------|---------|---------|--
###

test 'background; first cell; first 8 pixels', ->
  @video.update()
  expectedColors = [
    #R     G     B     A
    0x00, 0xFF, 0x00, 0xFF  # Green 00
    0x00, 0x00, 0xFF, 0xFF  # Blue  01
    0x00, 0x00, 0x00, 0xFF  # Black 10
    0xFF, 0x00, 0x00, 0xFF  # Red   11
    0xFF, 0x00, 0x00, 0xFF  # Red
    0x00, 0x00, 0x00, 0xFF  # Black
    0x00, 0x00, 0xFF, 0xFF  # Blue
    0x00, 0xFF, 0x00, 0xFF  # Green
  ]
  # first 8 pixels (0-7) of first cell in first row
  deepEqual @data[0...32], expectedColors

test 'background; first cell; last 8 pixels', ->
  @video.update()
  expectedColors = [
    #R     G     B     A
    0xFF, 0x00, 0x00, 0xFF  # Red   11
    0x00, 0x00, 0x00, 0xFF  # Black 10
    0x00, 0x00, 0xFF, 0xFF  # Blue  01
    0x00, 0xFF, 0x00, 0xFF  # Green 00
    0x00, 0xFF, 0x00, 0xFF  # Green
    0x00, 0x00, 0xFF, 0xFF  # Blue
    0x00, 0x00, 0x00, 0xFF  # Black
    0xFF, 0x00, 0x00, 0xFF  # Red
  ]
  # last 8 pixels of first cell in first row
  deepEqual @data[224...255], expectedColors

test 'background; last cell; first 8 pixels & last 8 pixels', ->
  @video.update()
  expectedColors = [
    #R     G     B     A
    0xFF, 0x20, 0x84, 0xFF  # Pink
    0xFF, 0x20, 0x84, 0xFF  # Pink
    0xFF, 0x20, 0x84, 0xFF  # Pink
    0xFF, 0x20, 0x84, 0xFF  # Pink
    0xFF, 0x20, 0x84, 0xFF  # Pink
    0xFF, 0x20, 0x84, 0xFF  # Pink
    0xFF, 0x20, 0x84, 0xFF  # Pink
    0xFF, 0x20, 0x84, 0xFF  # Pink
  ]
  # first 8 pixels (0-7) of last cell in last row
  startAddress = (39 * 8 * 60 * 8 + 59 * 8) * 4
  deepEqual @data[startAddress...(startAddress + 8 * 4)], expectedColors
  # last 8 pixels (0-7) of last cell in last row
  startAddress = (39 * 8 * 60 * 8 + 7 * 60 * 8 + 59 * 8) * 4
  deepEqual @data[startAddress...(startAddress + 8 * 4)], expectedColors

test 'background; last cell; 8 pixels in row 5', ->
  @video.update()
  expectedColors = [
    #R     G     B     A
    0xFF, 0x20, 0x84, 0xFF  # Pink
    0xFF, 0x20, 0x84, 0xFF  # Pink
    0x00, 0x00, 0x00, 0xFF  # Black
    0x00, 0x00, 0x00, 0xFF  # Black
    0x00, 0x00, 0x00, 0xFF  # Black
    0x00, 0x00, 0x00, 0xFF  # Black
    0xFF, 0x20, 0x84, 0xFF  # Pink
    0xFF, 0x20, 0x84, 0xFF  # Pink
  ]
  # 8 pixels of row 5 of last cell in last row
  startAddress = (39 * 8 * 60 * 8 + 5 * 60 * 8 + 59 * 8) * 4
  deepEqual @data[startAddress...(startAddress + 8 * 4)], expectedColors
