require("core/helper")

Widget = class("Widget")

function Widget:__init(x, y)
    self.x = x and x or 0
    self.y = y and y or 0
    self.width = 0
    self.height = 0

    self.clip = true

    self.children = {}
    self.hover = false
    self.active = false
    self.visible = true	
end

function Widget:clickEvent(x, y)
    if x < self.x or x > self.x + self.width or y < self.y or y > self.y + self.height then 
        -- outside widget area 
        return false
    end
    for k, v in pairs(self.children) do
        if v:clickEvent(x - self.x, y - self.y) then
            return true
        end
    end

    if self.onClick then
        self:onClick()
        return true
    end

    return false
end

function Widget:draw() 
    if self.visible then
        self:onDraw()

        love.graphics.push()
        love.graphics.translate(self.x, self.y)
        if self.clip then
            love.graphics.setScissor(0, 0, self.width, self.height)
        end

        for k, v in pairs(self.children) do
            v:draw()
        end

        love.graphics.setScissor()
        love.graphics.pop()
    end
end

function Widget:onDraw() end

function Widget:update(dt)
    self:onUpdate(dt)
    for k, v in pairs(self.children) do
        v:update(dt)
    end
end

function Widget:onUpdate(dt) end

function Widget:addChild(child)
    table.insert(self.children, child)
end
