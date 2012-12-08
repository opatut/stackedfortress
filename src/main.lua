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

lang = Lang("de_DE")


function _(key) return lang:_(key) end

debug = false
debugDraw = false

function reset()
    -- start game
    menu = MenuState()
    main = MainState()
    intro = IntroState()

    if debug then
        stack:push(main)
    else
        stack:push(intro)
    end
end

function love.load()
    math.randomseed(os.time())

    -- load images
    resources:addImage("stackling", "stackling.png")
    --resources:addImage("room", "room.png")
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
    stack:keypressed(k, u)

    if k == "d" and debug then
        debugDraw = not debugDraw
    end
end

function love.quit()
    settings:save()
end
