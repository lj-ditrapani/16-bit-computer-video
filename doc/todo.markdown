- Perhaps create the top-level name space to be video = {}
  instead of the Video function, so that you can more easily split
  the video.coffee file into smaller files when refactoring.
  As it is, depending on the Video class to be a name-space is brittle
  because the Video class must be defined before anything else.
- have 2 selectable views: normal or 4x zoom
  - normal is 1-to-1 host screen pixel to virtual screen pixel match
  - 4x zoom is 2x2 pixel host screen block for one virtual pixel
    use css style height/width to do the scaling automatically
