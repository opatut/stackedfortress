require("core/gamestack")
require("core/resources")
require("states/intro")
require("states/menu")
require("states/main")

resources = Resources("data/")
settings = Settings()
settings:load()
stack = GameStack()

function reset()
    -- start game
    menu = MenuState()
    main = MainState()
    intro = IntroState()

    --stack:push(menu)
    --stack:push(main)
    stack:push(intro)
end

function love.load()
    math.randomseed(os.time())

    -- load images
    resources:addImage("logo", "logo.png")
    resources:addImage("stackling", "stackling.png")
    resources:addImage("room", "room.png")

    resources:makeGradientImage("sky", {220, 230, 255}, {120, 160, 255})

    -- load fonts
    resources:addFont("title", "absender1.ttf", 80)
    resources:addFont("default", "DejaVuSans.ttf", 20)

    -- load music
    -- resources:addMusic("fanfare", "fanfare.mp3")

    resources:load()

    reset()
end

function love.update(dt)
    if not stack:current() then love.event.push("quit") end
    stack:update(dt)
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
