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

    self.mode = "control"

    self.buildModeSize = nil
    self.buildModePos = {0, 0}
end

function MainState:reset()
end

function MainState:update(dt)
    self.menu:update(dt)

    if self.running then
        self.world:update(dt)
    end

    -- shifting around the world
    local x, y = love.mouse.getPosition()
    local b = 10
    local speed = 5 * dt
    if x < b then self.world:shift(-speed, 0) end
    if x > love.graphics.getWidth()  - b then self.world:shift(speed, 0) end
    if y < b then self.world:shift(0, -speed) end
    if y > love.graphics.getHeight()  - b then self.world:shift(0, speed) end
end

function MainState:draw()
    love.graphics.setBackgroundColor(0, 0, 0)

    self.world:draw()

    if self.mode == "build" and self.buildModeSize then
        local wX, wY = self.world:screenToWorld(love.mouse.getPosition())
        if self.buildModeSize[1] % 2 == 0 then
            wX = wX - 0.5
        end
        wX = math.round(wX)
        if self.buildModeSize[1] % 2 == 0 then
            -- even width, add 0.5
            wX = wX + 0.5
        end
        wY = 0

        for i, room in pairs(self.world:ofType("Room")) do
            if math.abs(wX - room.x) < (self.buildModeSize[1] + room.w) * 0.5 then
                if wY > room.y - room.h then
                    wY = room.y - room.h
                end
            end
        end

        self.buildModePos = {wX, wY}

        -- draw a room rectangle at the position
        love.graphics.setColor(0, 255, 0, 128)
        love.graphics.rectangle("fill", wX - self.buildModeSize[1] / 2, wY - self.buildModeSize[2], self.buildModeSize[1], self.buildModeSize[2])

        -- draw the arrow above
        resources.shaders.arrow:send("time", self.world.time)
        love.graphics.setPixelEffect(resources.shaders.arrow)
        love.graphics.setColor(255, 255, 255, 100)
        local s = math.abs(math.sin(5 * self.world.time))
        love.graphics.draw(resources.images.arrow, wX, wY - 3 + s * 0.3, 0, 0.03, 0.03, 45, 105)
        love.graphics.setPixelEffect()
    end

    self.world:popTransform()

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(resources.fonts.small)

    love.graphics.print("[F11] Toggle Fullscreen", 10, 10)
    love.graphics.print("[Q] Quick exit", 10, 35)
    love.graphics.print("[Tab] Toggle Mode <" .. self.mode ..  ">", 10, 60)

    if self.mode == "build" then

        if self.buildModeSize then
            love.graphics.print("[Scroll] Change room size <" .. self.buildModeSize[1] .. "x" .. self.buildModeSize[2] .. ">", 10, 85)
        else
            love.graphics.print("[B] Build a new room", 10, 85)
        end
    end

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

    if k == "tab" then
        if self.mode == "build" then
            self.mode = "control"
            self.buildModeSize = nil
        elseif self.mode == "control" then
            self.mode = "build"
        end
    end

    if k == "b" and self.mode == "build" then
        if self.buildModeSize then
            self.buildModeSize = nil
        else
            self.buildModeSize = {1, 1}
        end
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
    local wX, wY = self.world:screenToWorld(x, y)

    -- Unit selection
    if self.mode == "control" then
        if button == "l" then
            local u = nil
            -- world.objects are sorted
            for k, v in pairs(self.world.objects) do
                if v.isAt and v:isAt(wX, wY) then
                    u = v
                end
            end
            if u ~= self.selectedUnit then self:selectUnit(u) end
        end
    elseif self.mode == "build" then
        if self.buildModeSize then
            if button == "l" then
                -- build and end
                self.world:add(Room(self.buildModePos[1], self.buildModePos[2],
                    self.buildModeSize[1], self.buildModeSize[2]))
                self.buildModeSize = nil
            elseif button == "wu" then
                self.buildModeSize[1] = self.buildModeSize[1] + 1
                if self.buildModeSize[1] > 3 then
                    self.buildModeSize[1] = 1
                    self.buildModeSize[2] = (self.buildModeSize[2] + 2) % 2 + 1
                end
            elseif button == "wd" then
                self.buildModeSize[1] = self.buildModeSize[1] - 1
                if self.buildModeSize[1] == 0 then
                    self.buildModeSize[1] = 3
                    self.buildModeSize[2] = (self.buildModeSize[2] + 2) % 2 + 1
                end
            end
        end
    end
end
