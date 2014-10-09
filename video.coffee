###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
---------|---------|---------|---------|---------|---------|---------|--
###


if (typeof ljd).toString() == 'undefined'
  window.ljd = {}


# Modifies data to produce the new screen data (for 4x zoom)
newScreen4x = (offset, ram, data) ->


class ljd.Video

  constructor: (@offset, @ram, @context, @zoom) ->
    width = element.width
    height = element.height
    @imageData = @context.createImageData(width, height)

  update: ->
    newScreen4x @offset, @ram, @imageData
    @context.putImageData(@imageData, 0, 0)


ljd.Video.newScreen4x = newScreen4x
