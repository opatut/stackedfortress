-- main game state

require("core/gamestate")
require("core/resources")
require("objects/world")

MainState = class("MainState", GameState)

function MainState:__init()
    self.menu = Menu({"Continue", "Save", "Exit to Menu", "Exit to Desktop"},
        function(number, text)
            if number == 1 then
                self:toggleMenu()
            elseif number == 3 then
                self.menu:hide(function() stack:pop() end)
            elseif number == 4 then
                if debug then 
                    stack:quit()
                else
                    self.menu:hide(function() stack:quit() end)
                end
            end
        end)

    self.world = World()

    self.selectedUnit = nil
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

    self.world:popTransform()

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
        self:toggleMenu()
    end

    if k == "q" then
        stack:quit()
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

function MainState:selectUnit(unit)
    if unit == self.selectedUnit then return end

    if self.selectedUnit then
        if self.selectedUnit.onDeselect then 
            self.selectedUnit:onDeselect()
        end
        self.selectedUnit.selected = false
    end

    self.selectedUnit = unit

    if self.selectedUnit then
        if self.selectedUnit.onSelect then 
            self.selectedUnit:onSelect()
        end
        self.selectedUnit.selected = true
    end
end

function MainState:mousepressed(x, y, button)
    -- transform coordinates
    local ox, oy = self.world:getOffset()
    local scale = self.world:getZoom()
    x = (x - ox) / scale
    y = (y - oy) / scale

    local u = nil
    -- world.objects are sorted
    for k, v in pairs(self.world.objects) do
        if v.isAt and v:isAt(x, y) then
            u = v
        end
    end
    if u ~= self.selectedUnit then self:selectUnit(u) end
end
