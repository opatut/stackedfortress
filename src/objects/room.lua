require("core/object")

Room = class("Room", Object)

function Room:__init(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w or 1
    self.h = h or 1
end

function Room:update(dt)
end

function Room:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(resources.images.room, self.x, self.y, 0, 0.01 * self.w, 0.01, 50, 85)

    if self.h > 1 then
        love.graphics.setColor(57, 57, 57)
        love.graphics.rectangle("fill", self.x - self.w / 2, self.y - self.h + 0.15, self.w, self.h - 1)
    end
end
