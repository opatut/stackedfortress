require("core/helper")

Widget = class("Widget")

function Widget:__init(x, y)
    self.x = x and x or 0
    self.y = y and y or 0
    self.width = 0
    self.height = 0

    self.clip = true

    self.parent = nil
    self.children = {}
    self.active = false
    self.visible = true	
end

function Widget:absolutePosition()
    if not self.parent then
        return self.x, self.y
    else
        local x, y = self.parent:absolutePosition()
        return self.x + x, self.y + y
    end
end

function Widget:isHover()
    local x, y = love.mouse.getPosition()
    if self.parent then
        local px, py = self.parent:absolutePosition()
        x = x - px
        y = y - py
    end
    return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height 
end

function Widget:clickEvent(x, y)
    if not self:isHover() then 
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
    child.parent = self
    table.insert(self.children, child)
end
