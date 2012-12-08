-- main game state

require("core/gamestate")
require("core/resources")
require("core/settings")
require("core/curves")
require("core/menu")
require("core/i18n")

MenuState = class("MenuState", GameState)

function MenuState:__init()
    self.time = 0
    self.menu = Menu({_("newGame"), _("loadGame"), _("multiplayer"), _("options"), _("credits"), _("exit")},
        function(number, text)
            if number == 1 then
                self.menu:hide(function()
                    main:reset()
                    stack:push(main)
                end)
            elseif number == 4 then
                self.menu:hide(function() self.options:show() end)
            elseif number == 6 then
                self.menu:hide(function() stack:quit() end)
            end
        end)

    self.options = Menu({"Debug: " .. (debug and "on" or "off"), "Test 2", "Back"},
        function(number, text)
            if number == 1 then
                debug = not debug
                self.options.entries[1] = "Debug: " .. (debug and "on" or "off")
            elseif number == 3 then
                self.options:hide(function() self.menu:show() end)
            end
        end)
end

function MenuState:update(dt)
    self.time = self.time + dt
    self.menu:update(dt)
    self.options:update(dt)
end

function MenuState:draw()
    love.graphics.setBackgroundColor(0, 0, 0)

    -- background
    love.graphics.setColor(255, 255, 255, curves.sin(0, 255, self.time * 2))
    love.graphics.setFont(resources.fonts.title)
    love.graphics.print("Stacked",  40, curves.sin(40, 60, self.time * 2))
    love.graphics.print("Fortress", 40, curves.sin(110, 130, self.time * 2))

    love.graphics.setFont(resources.fonts.default)
    self.menu:draw(40, 170)
    self.options:draw(40, 170)
end

function MenuState:start()
    self.menu:show()
    self.time = 0
end

function MenuState:stop()
end

function MenuState:keypressed(k, u)
    if k == "escape" then
        stack:pop()
        stack:pop()
    elseif k == " " or k == "return" or k == "enter" or k == "right" then
        self.menu:trigger()
        self.options:trigger()
    elseif k == "down" then
        self.menu:next()
        self.options:next()
    elseif k == "up" then
        self.menu:previous()
        self.options:previous()
    end
end
