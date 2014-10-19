<!-- Author:  Lyall Jonathan Di Trapani =========|=========|======== -->
Video subsystem for LJD 16-bit computer
=======================================

Author:  Lyall Jonathan Di Trapani

```
480 x 320 pixel screen
60 x 40 grid of tiles
8 x 8 pixel tiles
256 tile index
Tile index is used for both background cells and sprites
Colors are 15-bits with (5:5:5) RGB color format

```


Video Ram
---------
```
5,068 Words (< 10 KB)

                Words   Address Range   Description
----------------------------------------------------------------------
Tile index      2,048   $EC00-$F3FF     256 tiles X 8 words
Grid cells      2,400   $F400-$F59D     60 X 40 cells
Cell x y flip     300   $FD60-$FE8B     2 bit X 2,400 / 16
Sprites           256   $FE8C-$FF8B     attribute data for 128 sprites
Cell colors        32   $FF8C-$FFAB     32 cell colors
Sprite colors      32   $FFAC-$FFCB     32 sprite colors
----------------------------------------------------------------------
Total           5,068
```


Tiles
-----
Each pixel in a tile is represented by 2-bits.  Each 2-bit value indexes into the selected four colors.
```
Size:  8 words
8 x 8 pixel tiles = 64 pixels
2-bits per pixel
Each word contains a row of 8 pixels
For a given pixel in a tile, bit one selects the color pair,
and bit zero selects the color. 
00 -> pair 0, color 0
01 -> pair 0, color 1
10 -> pair 1, color 0
11 -> pair 1, color 1
```


Grid Cell
---------
```
Size:  1 word
Color pairs are indexed into the cell colors (not the sprite colors)
Sprite data:

                    # of bits
------------------------------------
Tile index          8
Color pair 1 (cp1)  4
Color pair 2 (cp2)  4
------------------------------------
Total              16 bits = 1 word


Layout of a grid cell in RAM:

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|   Tile Index  |  cp1  |  cp2  |
---------------------------------
```


Cell X Y Flip
-------------
Each background tile in the grid cell can be flipped about the x axis or
the y axis.  This requires 2-bits per cell.  Bit one is for flipping about the x axis and bit 0 is for flipping about y axis.


Sprites
-------
```
Size:  2 words
Sprite data:

                    # of bits
------------------------------------
Tile index          8
Color pair 1 (cp1)  4
Color pair 2 (cp2)  4
Mirror flip x (X)   1
Mirror flip y (Y)   1
x position          6
Unused (U)          2
y position          6
------------------------------------
Total              32 bits = 2 words


Layout of a sprite across 2 RAM cells:

 F E D C B A 9 8 7 6 5 4 3 2 1 0       F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------     ---------------------------------
|   Tile Index  |  cp1  |  cp2  |     |X|Y| xposition |U|U| yposition |
---------------------------------     ---------------------------------
```


Colors Pairs
------------
```
There are 2 sets of color pairs:  cell and sprite
Each set has 32 colors arranged in 16 pairs
16 x 2 x 15-bit colors
4-bit color pair index
```

Colors
------
```
A color occupies the 15 least-significant bits in a 16-bit value
Colors are stored as 16-bit numbers; the most-significant bit is unused.

U Unused
R Red color component
G Green color component
B Blue color component

Layout of a color

 F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------
|U|R R R R R|G G G G G|B B B B B|
---------------------------------
```


Video hardware
--------------
```
Instead of doing copy over to video RAM, use triple buffer
So just swap buffers instead of doing copy; instantaneous.
Do the same for all I/O.

If not using triple buffers (obsolete):
---------------------------------------
First 90 ms of frame:  CPU controls RAM lines
Next 10 ms of frame:  CPU sleeps
    video chip controls RAM Address and data out lines
Video copies video RAM into local video ram (4,480 words)
Control returned to CPU
Video ram draws info to screen in continuous loop for next 90 ms

Video loop 1 (7 operations)
---------------------------
1) Use row/col counters to load tile cell
2) Use cell color pair IDs to load 4 colors from color pairs
3) Use row/col counters and tile ID to load tile row
4) increment row/col counters as necessary
5) Switch buffers and goto 1)

Video loop 2 (8 operations)
---------------------------
1) Draw 8 pixel row to screen (16-bit row)
2) Switch buffers Goto 1)

153 k cycles to complete
160 k * 6 = 960 k cycles
1.8 million cycles available
```
