function love.conf(t)
    t.title = "StackedFortress"
    t.author = "opatut"
    t.identity = "stackedfortress"
    t.version = "0.8.0" -- Löve version
    t.console = false
    t.release = false
    t.screen.width = 1088
    t.screen.height = 612
    t.screen.fullscreen = false
    t.screen.vsync = true
    t.screen.fsaa = 0
    t.modules.joystick = true
    t.modules.audio = true
    t.modules.keyboard = true
    t.modules.event = true
    t.modules.image = true
    t.modules.graphics = true
    t.modules.timer = true
    t.modules.mouse = true
    t.modules.sound = true
    t.modules.physics = true
end

