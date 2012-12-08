require("core/objectgroup")
require("core/navmesh")
require("objects/stackling")
require("objects/room")

World = class("World", ObjectGroup)

function World:__init()
    ObjectGroup.__init(self)

    self.navmesh = {}

    self:add(Stackling())
    self:add(Room(0, 0, 2, 2))
    self:add(Room(2, 0, 2, 1))
    --self:add(Room(2, -1, 2, 1))

    self.time = 0
end

function World:update(dt)
    ObjectGroup.update(self, dt)

    self.time = self.time + dt
end

function World:getZoom()
    return math.min(love.graphics.getWidth(), love.graphics.getHeight()) / 20
end

function World:getOffset()
    return love.graphics.getWidth() / 2, love.graphics.getHeight() * 4 / 5
end

function World:pushTransform()
    love.graphics.push()
    love.graphics.translate(self:getOffset())
    love.graphics.scale(self:getZoom())
end

function World:popTransform()
    love.graphics.pop()
end

function World:draw()
    love.graphics.setBackgroundColor(120, 160, 255) -- blue sky

    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(resources.images.sky, 0, 0, 0, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

    self:pushTransform()

    -- draw ground
    love.graphics.setColor(166, 80, 43)
    local w = love.graphics.getWidth() / self:getZoom()
    love.graphics.rectangle("fill", -w / 2, 0, w, 5)

    ObjectGroup.draw(self)

    if debugDraw then
        for i, node in pairs(self.navmesh) do
            node:drawDebug()
        end
    end
end
