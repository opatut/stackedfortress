require("core/object")

Cannon = class("Cannon", Object)

function Cannon:__init(room, position)
    Object.__init(self)

    self.angleBarrel = 0

    -- positions: 0 left, 1 top, 2 right
    if position == 0 then
        self.x = room.x - 1
        self.y = room.y - 1
        self.z = 1
        self.angle = math.pi
    end

    if position == 1 then
        self.x = room.x + room.w / 2
        self.y = room.y - 1
        self.angle = - math.pi / 2
    end

    if position == 2 then
        self.x = room.x + room.w
        self.y = room.y - 1
        self.angle = 0
    end

    self.angleBarrel = self.angle
end

function Cannon:update(dt)
    self.angleBarrel = self.angleBarrel + dt
end

function Cannon:draw()
    love.graphics.draw(resources.images.cannonbarrel, self.x, self.y,
                       self.angleBarrel, 0.01, 0.01, 0, 50)
    love.graphics.draw(resources.images.cannonbase, self.x, self.y,
                       self.angle, 0.01, 0.01, 0, 50)
end