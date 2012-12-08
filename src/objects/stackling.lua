require("core/object")

Stackling = class("Stackling", Object)

function Stackling:__init()
    Object.__init(self)
    self.team = {}
    self.team.color = {255, 0, 0}
    self.z = 1
end

function Stackling:isAt(x, y)
	return x >= self.x - 4 / 32 and x <= self.x + 4 / 32 and y >= self.y - 14 / 32 and y <= self.y
end

function Stackling:update(dt) end

function Stackling:draw()
	if self.selected then
		local c = self.team.color
		love.graphics.setColor(math.min(255, c[1] + 100), math.min(255, c[2] + 100), math.min(255, c[3] + 100))
	else
    	love.graphics.setColor(self.team.color)
    end
    love.graphics.draw(resources.images.stackling, self.x, self.y, 0, 1/32, 1/32, 4, 14)
end
