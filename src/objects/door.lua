require("core/object")

Door = class("Door", Object)

function Door:__init(roomA, roomB)
    -- swap rooms if not left/right ordered
    if roomA.x > roomB.x then roomA, roomB = roomB, roomA end
    self.leftRoom = roomA
    self.rightRoom = roomB

    self.y = roomA.y
    self.x = roomA.x + roomA.w / 2
    self.z = 0.5
end

function Door:update(dt)end

function Door:draw()
    love.graphics.setColor(255, 255, 255)
    local w, h = 0.2, 0.5
    love.graphics.draw(resources.images.door, self.x, self.y, 0, w / 2, h / 2, 1, 2)
end