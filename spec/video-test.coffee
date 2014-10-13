###
Author:  Lyall Jonathan Di Trapani
LJD 16-bit Computer Video Sub-system
---------|---------|---------|---------|---------|---------|---------|--
###


e = ljd.$("test")
e.innerHTML = "new"

c = ljd.$("screen")
#c.style.height = '320px'
#c.style.height = '640px'
#c.style.height = '960px'
c.style.height = '1280px'
ctx = c.getContext("2d")

ram = ljd.makeRAM()
v = new ljd.Video(ram, ctx, 4)
v.update()
