require("core/gamestack")
require("core/resources")
require("states/intro")
require("states/menu")
require("states/main")
require("core/i18n")

resources = Resources("data/")
settings = Settings()
settings:load()
stack = GameStack()

savedLanguage = settings:get("language", "de_DE")
lang = Lang(savedLanguage) --"de_DE" or "en_US"
fullscreen = false

function _(key) return lang:_(key) end

debug = settings:get("debug", false)
debugDraw = false

function reset()
    -- start game
    menu = MenuState()
    main = MainState()
    intro = IntroState()

    if debug then
        stack:push(menu)
        stack:push(main)
    else
        stack:push(intro)
    end
end

function love.load()
    math.randomseed(os.time())

    if not debug then
        love.mouse.setGrab(true)
    end

    -- load images
    resources:addImage("stackling", "stackling.png")
    resources:addImage("arrow", "arrow.png")
    resources:makeGradientImage("room", {30, 30, 30}, {57, 57, 57})
    resources:makeGradientImage("sky", {220, 230, 255}, {120, 160, 255})
    resources:makeGradientImage("door", {100, 100, 100}, {150, 150, 150}, true)

    -- load fonts
    resources:addFont("title", "absender1.ttf", 80)
    resources:addFont("subtitle", "absender1.ttf", 40)
    resources:addFont("default", "DejaVuSans.ttf", 20)
    resources:addFont("small", "DejaVuSans.ttf", 14)

    -- load music
    -- resources:addMusic("fanfare", "fanfare.mp3")
    resources:addShader("arrow", "shaders/arrow.glsl")
    resources:addShader("sky", "shaders/daylight.glsl")

    resources:load()
    reset()
end

function love.update(dt)
    stack:update(dt)
    if not stack:current() then love.event.push("quit") end
end

function love.draw()
    stack:draw()
end

function love.keypressed(k, u)
    if k == "d" and debug then
        debugDraw = not debugDraw
    end

    if k == "tab" and love.keyboard.isDown("lalt") then
        love.mouse.setGrab(false)
        return
    end
    if k == "f11" then  --toggels fullscreen
        if not fullscreen then
            -- save old window size
            windowedSizeX, windowedSizeY = love.graphics.getMode()

            modes = love.graphics.getModes()
            table.sort(modes, function(a, b) return a.width*a.height < b.width*b.height end)
            local nativeResolution = modes[#modes]
            love.graphics.setMode(nativeResolution["width"], nativeResolution["height"], true)
        else
            love.graphics.setMode(windowedSizeX, windowedSizeY, false)
        end
        fullscreen = not fullscreen
    end
    stack:keypressed(k, u)
end

function love.keyreleased(k, u)
    stack:keyreleased(k, u)
end

function love.mousepressed(x, y, button)
    love.mouse.setGrab(true)
    stack:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    stack:mousereleased(x, y, button)
end

function love.quit()
    settings:set("debug", debug)
    settings:set("language", savedLanguage)
    settings:save()
end
