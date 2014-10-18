- Change 16-bit color format from 5-6-5 RGB to 15-bit 5-5-5 RGB
- Refactor background last cell test?  Use a loop (same color x 8)?
- Perhaps create the top-level name space to be video = {}
  instead of the Video function, so that you can more easily split
  the video.coffee file into smaller files when refactoring.
  As it is, depending on the Video class to be a name-space is brittle
  because the Video class must be defined before anything else.
- have 2 selectable views: normal or 4x zoom
  - normal is 1-to-1 host screen pixel to virtual screen pixel match
  - 4x zoom is 2x2 pixel host screen block for one virtual pixel
    use css style height/width to do the scaling automatically
- Reset sprites on updateData
  Since previous data structures are thrown away at each frame
  all cells are recreated and default to sprite = false
  But if it was rewritten to recycle data structures across frames
  setGridSprites() function
  # If recycling data structures, be sure to clear
  # all sprites at beginning
  # Must ensure if a sprite already exists on cell
  # do not replace with new one, keep old sprite
