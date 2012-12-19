require("core/objectgroup")
require("core/navmesh")
require("objects/stackling")
require("objects/room")
require("objects/cannon")

World = class("World", ObjectGroup)

function World:__init()
    ObjectGroup.__init(self)

    self.navmesh = {}

    self:add(Stackling())
    room1 = Room(-1.5, 0, 2, 2)
    room2 = Room(0.5, 0, 2, 1)
    self:add(room1)
    self:add(room2)
    self:add(Cannon(room1))

    self.time = 0
    self.centerX = 0
    self.centerY = 0
end

function World:update(dt)
    ObjectGroup.update(self, dt)

    self.time = self.time + dt
end

function World:getZoom()
    return math.min(love.graphics.getWidth(), love.graphics.getHeight()) / 20
end

function World:getOffset()
    return
        love.graphics.getWidth() / 2      - self.centerX * self:getZoom(),
        love.graphics.getHeight() * 4 / 5 - self.centerY * self:getZoom()
end

function World:screenToWorld(x, y)
    local ox, oy = self:getOffset()
    local scale = self:getZoom()
    return (x - ox) / scale, (y - oy) / scale
end

function World:shift(x, y)
    self.centerX = self.centerX + x
    self.centerY = self.centerY + y
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
    local daytime = (self.time / 300 + 0.3) % 1
    local daytimeShader = math.sin(daytime * math.pi * 2 - math.pi * 0.5) * 0.5 + 0.5

    love.graphics.setBackgroundColor(30, 30, 30)

    love.graphics.setColor(255, 255, 255)
    love.graphics.setPixelEffect(resources.shaders.sky)
    resources:sendShaderValue("sky", "daytime", daytimeShader)
    love.graphics.draw(resources.images.sky, 0, 0, 0, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    love.graphics.setPixelEffect()

    self:pushTransform()

    -- draw sun/moon
    local hX = self.centerX
    local r = 17  --  - love.graphics.getHeight() * 0.4 / self:getZoom() + self.centerY
    local x, y = math.sin(- daytime * math.pi * 2) * r, math.cos(- daytime * math.pi * 2) * r
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(resources.images.sun, x + hX, y, 0, 0.02, 0.02, 128, 128)
    love.graphics.draw(resources.images.moon, -x + hX, -y, 0, 0.02, 0.02, 128, 128)

    -- draw ground
    love.graphics.setColor(166, 80, 43)
    local w = love.graphics.getWidth() / self:getZoom()
    love.graphics.rectangle("fill", -w / 2 + hX, 0, w, self.centerY + love.graphics.getHeight() * 4 / 5 / self:getZoom())

    ObjectGroup.draw(self)

    if debugDraw then
        for i, node in pairs(self.navmesh) do
            node:drawDebug()
        end
    end
end
