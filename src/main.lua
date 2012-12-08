require("core/gamestack")
require("core/resources")
require("states/intro")
require("states/menu")
require("states/main")

resources = Resources("data/")
settings = Settings()
settings:load()
stack = GameStack()

debug = true

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
    resources:addImage("room", "room.png")

    resources:makeGradientImage("sky", {220, 230, 255}, {120, 160, 255})

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
end

function love.quit()
    settings:save()
end
