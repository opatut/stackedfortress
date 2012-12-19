require("gui/widget")

Button = class("Button", Widget)

function Button:__init() 
    Widget.__init(self)
end

function Button:onDraw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(resources.images.button, self.x, self.y, 0, 0.01 * self.width, 0.01 * self.height)
end

function Button:onUpdate(dt) end
