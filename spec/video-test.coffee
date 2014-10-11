###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
---------|---------|---------|---------|---------|---------|---------|--
###


if (typeof ljd).toString() == 'undefined'
  window.ljd = {}

setPixel = (x, y, r, g, b) ->
  index = (x + y * imageData.width) * 4
  data[index + 0] = r
  data[index + 1] = g
  data[index + 2] = b
  data[index + 3] = 255

e = ljd.$("test")
e.innerHTML = "new"

c = ljd.$("screen")
c.style.height = '640px'

ctx = c.getContext("2d")
# ctx.fillStyle = "#AAAAAA"
# ctx.fillRect(0, 0, 480, 320)

v = new ljd.Video([], ctx, 4)

imageData = v.imageData
data = imageData.data

setPixel(1, 1, 255, 0, 0)
for x in [5..10]
  for y in [5..10]
    setPixel(x, y, 255, 0, 0)
ctx.putImageData(imageData, 0, 0)
