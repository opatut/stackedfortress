require("gui/widget")

Button = class("Button", Widget)

function Button:__init(text, x, y) 
    Widget.__init(self, x, y)
    self.width = 150
    self.height = 35
    self.text = text
end

function Button:onDraw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(resources.images.button, self.x, self.y, 0, 0.01 * self.width, 0.01 * self.height)
    love.graphics.print(self.text, self.x + self.width / 2 - love.graphics.getFont():getWidth(self.text) / 2, 
        self.y + self.height / 2 - love.graphics.getFont():getHeight() / 2)
end

function Button:onUpdate(dt) end

function Button:onClick()
    print(self.text)
end