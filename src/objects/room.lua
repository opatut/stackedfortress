require("core/object")

Room = class("Room", Object)

function Room:__init(x, y, w, h)
    self.x = x
    self.y = y
    self.z = 0
    self.w = w or 1
    self.h = h or 1

    self.navnodes = {}
    self.leftNode = nil
    self.rightNode = nil
end

function Room:update(dt)
end

function Room:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(resources.images.room, self.x, self.y, 0, 0.01 * self.w, 0.01, 50, 85)

    if self.h > 1 then
        love.graphics.setColor(57, 57, 57)
        love.graphics.rectangle("fill", self.x - self.w / 2, self.y - self.h + 0.15, self.w, self.h - 1)
    end

    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("line", self.x - self.w * 0.5, self.y - self.h + 0.15, self.w, self.h)
end

function Room:addNavNode(node)
    table.insert(self.group.navmesh, node)
    table.insert(self.navnodes, node)
end

function Room:onAdd(group)
    -- add some nodes on the ground and connect them

    local prev
    for x = 1, self.w do
        local node = NavNode(self.x + x - self.w / 2 - 0.5, self.y)
        
        if prev then 
            node:connect(prev) 
        else
            self.leftNode = node 
        end
        
        self:addNavNode(node)
        prev = node
    end
    self.rightNode = prev

    -- now search a room left of this one
    for k, v in pairs(group:ofType("Room")) do
        if v ~= self and v.y == self.y then
            print("vx", v.x, "vw", v.w, "sx", self.x, "sw", self.w)

            -- same level
            if v.x + v.w == self.x then
                -- left of this
                self.leftNode:connect(v.rightNode)
            end

            if self.x + self.w == v.x then
                -- right of this
                self.rightNode:connect(v.leftNode)
            end
        end
    end
end

function Room:onRemove(group) 
    for k, n in pairs(self.navnodes) do
        n:destroy()
    end
end
