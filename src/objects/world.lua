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

function World:draw()
    love.graphics.setBackgroundColor(120, 160, 255) -- blue sky

    love.graphics.draw(resources.images.sky, 0, 0, 0, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

    -- do transformations
    love.graphics.push()
    love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() * 4 / 5)

    self.zoom = math.min(love.graphics.getWidth(), love.graphics.getHeight()) / 20
    love.graphics.scale(self.zoom)

    -- draw ground
    love.graphics.setColor(166, 80, 43)
    local w = love.graphics.getWidth() / self.zoom
    love.graphics.rectangle("fill", -w / 2, 0, w, 5)

    ObjectGroup.draw(self)

    if debugDraw then
        for i, node in pairs(self.navmesh) do
            node:drawDebug()
        end
    end

    love.graphics.pop()
end
