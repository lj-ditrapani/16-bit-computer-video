###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
---------|---------|---------|---------|---------|---------|---------|--
###


if (typeof ljd).toString() == 'undefined'
  window.ljd = {}

# offset = 0xDB00 # 55,296

class Video

  constructor: (@ram, @offset, @context, @zoom) ->
    @x = 0

  update: ->
    switch @x
      when 0
        @context.fillStyle = "#990000"
        @x = 1
      when 1
        @context.fillStyle = "#009900"
        @x = 2
      when 2
        @context.fillStyle = "#000099"
        @x = 0
    @context.fillRect(10, 10, 90, 90)


e = ljd.$("test")
e.innerHTML = "new"

c = ljd.$("screen")

ctx = c.getContext("2d")
ctx.fillStyle = "#222222"
ctx.fillRect(0, 0, 960, 640)
ctx.fillStyle = "#AAAAAA"
ctx.fillRect(0, 0, 480, 320)
ctx.fillStyle = "#333333"
ctx.fillRect(110, 10, 90, 90)

v = new Video(1, 1, ctx)

draw = ->
  window.setTimeout(draw, 500)
  v.update()

window.setTimeout(draw, 500)

