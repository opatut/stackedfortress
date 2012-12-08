-- intro

require("core/gamestate")
require("core/resources")

IntroState = class("IntroState", GameState)

function IntroState:__init()
    self.time = 0
end

function IntroState:update(dt)
    self.time = self.time + dt

    if self.time >= 3 then
        stack:push(menu)
    end
end

function IntroState:draw()
    local c = 0
    if self.time < 0 then
        c = 0
    elseif self.time < 1 then
        c = self.time * 255
    elseif self.time < 2 then
        c = 255
    elseif self.time < 3 then
        c = (3 - self.time) * 255
    else
        c = 0
    end

    love.graphics.setBackgroundColor(17, 17, 17)
    love.graphics.setColor(255, 255, 255, c)

    local i = resources.images.logo
    love.graphics.draw(i, love.graphics.getWidth() / 2 - i:getWidth() / 2, love.graphics.getHeight() / 2 - i:getHeight() / 2)
end

function IntroState:start()
    self.time = -1
end

function IntroState:keypressed(k, u)
    stack:push(menu)
end
