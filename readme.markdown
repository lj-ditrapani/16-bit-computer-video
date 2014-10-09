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
Colors are 16-bits with (5:6:5) RGB color format
```


Video Ram
---------


```
5,068 Words (< 10 KB)

                words   address range
-------------------------------------
Tile index      2,048   $EC00-$F3FF
Grid cells      2,400   $F400-$F59D
Cell x y flip     300   $FD60-$FE8B
Sprites           256   $FE8C-$FF8B
Tile colors        32   $FF8C-$FFAB
Sprite colors      32   $FFAC-$FFCB
-------------------------------------
Total           5,068

------------------------------------------------------------------
Single tile        8    Words   8 X 8 tile times 2 bits
                                (16 bits per word)
Tile index      2048    Words   256 tiles X 8 words
Each tile cell     1    Word    8 bit tile select +
                                4 bit foreground color pair +
                                4 bit background color pair
Number of cells 2400            60 X 40 grid cells
cell x y flip    300    Words   2 bit X 2,400 / 16
Sprites          256    attribute data for 128 sprites
32 tile colors    32    Words
32 sprite colors  32    words


16 x 2 x 16-bit colors
(16 pairs of 16-bit colors)
4 bit color pair index
8x8 pixel tiles
```

Sprites
-------
```
128 sprites
2 words per sprite
256 words of sprite data


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


Layout of a sprite accross 2 RAM cells:

 F E D C B A 9 8 7 6 5 4 3 2 1 0       F E D C B A 9 8 7 6 5 4 3 2 1 0
---------------------------------     ---------------------------------
|   Tile Index  |  cp1  |  cp2  |     |X|Y| xposition |U|U| yposition |
---------------------------------     ---------------------------------
```


Video hardware
--------------
```
Instead of doing copy over to video RAM, could use double buffer
So just swap buffers instead of doing copy; instantaneous!
Could do the same for all I/O.

First 90 ms of frame:  CPU controls RAM lines
Next 10 ms of frame:  CPU sleeps
    video chip controls RAM Address and data out lines
Video copies video RAM into local video ram (4,480 words)
Control returned to CPU
Video ram draws info to screen in continuous loop for next 90 ms

Video loop 1 (7 operations)
------------
1) Use row/col counters to load tile cell
2) Use tile slot color pair IDs to load 4 colors from color pairs
3) Use row/col counters and tile ID to load tile row
4) increment row/col counters as necessary
5) Switch buffers and goto 1)

Video loop 2 (8 operations)
------------
1) Draw 8 pixel row to screen (16-bit row)
2) Switch buffers Goto 1)

153 k cycles to complete
160 k * 6 = 960 k cycles
1.8 million cycles available
```
