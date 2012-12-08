-- navigation nodes

NavNode = class("NavNode")

function NavNode:__init(x, y)
    self.x = x
    self.y = y
    self.connections = {}
end

function NavNode:destroy()
    for i, c in pairs(self.connections) do
        self:disconnect(c)
    end
end

function NavNode:disconnect(other)
    table.removeValue(self.connections, other)
    table.removeValue(other.connections, self)
end 

function NavNode:connect(other)
    table.insert(self.connections, other)
    table.insert(other.connections, self)
end

function NavNode:drawDebug()
    love.graphics.setColor(0, 0, 255)
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(0.05)
    for i, node in pairs(self.connections) do
        love.graphics.line(self.x, self.y, node.x, node.y)
    end

    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("fill", self.x, self.y, 0.1, 10)
end
