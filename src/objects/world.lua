require("core/object")
require("objects/stackling")
require("objects/room")
require("core/navmesh")

World = class("World", Object)

function World:__init()
    self.rooms = {}
    self.objects = {}

    table.insert(self.objects, Stackling())
    table.insert(self.rooms, Room(0, 0, 2, 2))

    local n1 = NavNode(2, -1)
    local n2 = NavNode(3, -1)
    local n3 = NavNode(2, -2)
    local n4 = NavNode(0, -2)

    n1:connect(n2)
    n2:connect(n3)
    n1:connect(n3)
    n4:connect(n3)

    self.navmesh = {n1, n2, n3, n4}
end

function World:update(dt)
    for i, room in pairs(self.rooms) do
        room:update(dt)
    end

    for i, object in pairs(self.objects) do
        object:update(dt)
    end
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

    for i, room in pairs(self.rooms) do
        room:draw()
    end

    for i, object in pairs(self.objects) do
        object:draw()
    end

    for i, node in pairs(self.navmesh) do
        node:drawDebug()
    end

    love.graphics.pop()
end
