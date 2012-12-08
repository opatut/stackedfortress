-- main game state

require("core/gamestate")
require("core/resources")
require("objects/world")

MainState = class("MainState", GameState)

function MainState:__init()
    self.menu = Menu({"Continue", "Save", "Exit"},
        function(number, text)
            if number == 1 then
                self.menu:hide(function() self.running = true end)
            elseif number == 3 then
                self.menu:hide(function() stack:pop() end)
            end
        end)

    self.world = World()
end

function MainState:reset()
end

function MainState:update(dt)
    self.menu:update(dt)

    if self.running then
        self.world:update(dt)
    end
end

function MainState:draw()
    love.graphics.setBackgroundColor(0, 0, 0)

    self.world:draw()

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(resources.fonts.default)
    love.graphics.print(self.running and "running" or "not running", 10, 10)

    -- PAUSE MENU
    if self.menu:isVisible() then
        love.graphics.setColor(0, 0, 0, curves.sin(0, 128, self.menu.fade))
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        -- love.graphics.setFont(resources.fonts.title)

        love.graphics.setFont(resources.fonts.default)
        self.menu:draw(100, 100)
    end
end

function MainState:start()
    self.running = true
end

function MainState:stop()
end

function MainState:toggleMenu()
    if self.running then
        self.running = false
        self.menu:show()
    else
        self.menu:hide(function() self.running = true end)
    end
end

function MainState:keypressed(k, u)
    if k == "escape" then
        if debug then
            stack:pop()
        else
            self:toggleMenu()
        end
    end

    if k == "p" then
        self:toggleMenu()
    end

    if k == "f" then 
        -- take the first and last node and find the path
        -- print the length
        local path = self.world.navmesh[1]:findPath(self.world.navmesh[#self.world.navmesh])
        print("Path of length", path[1], "over", #path[2], "nodes.")
        for k, v in pairs(path[2]) do
            print("Node: " .. v.x .. "|" .. v.y)
        end
    end

    if self.menu.shown then
        if k == " " or k == "return" or k == "enter" or k == "right" then
            self.menu:trigger()
        elseif k == "down" then
            self.menu:next()
        elseif k == "up" then
            self.menu:previous()
        end
    end
end
