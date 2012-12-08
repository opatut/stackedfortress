require("core/object")

Stackling = class("Stackling", Object)

function Stackling:__init()
    Object.__init(self)
    self.team = {}
    self.team.color = {255, 0, 0}
    self.z = 1
end

function Stackling:update(dt)
    
end

function Stackling:draw()
    love.graphics.setColor(self.team.color)
    love.graphics.draw(resources.images.stackling, self.x, 0, 0, 1/32, 1/32, 4, 14)
end
