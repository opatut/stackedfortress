require("core/helper")

Object = class("Object")

function Object:__init()
    self.x = 0
    self.y = 0
    self.angle = 0
end

function Object:update(dt)end
function Object:draw()end
