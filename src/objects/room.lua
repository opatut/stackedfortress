require("core/object")
require("objects/door")

Room = class("Room", Object)

function Room:__init(x, y, w, h)
    self.x = x
    self.y = y
    self.z = 0
    self.w = w or 1
    self.h = h or 1

    self.navnodes = {}
    self.doors = {}
    self.leftNode = nil
    self.rightNode = nil
end

function Room:update(dt)
end

function Room:draw()
    --love.graphics.setColor(255, 255, 255)
    --love.graphics.draw(resources.images.room, self.x, self.y, 0, 0.01 * self.w, 0.01, 50, 85)

    -- room
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(resources.images.room, self.x, self.y, 0, 0.5 * self.w, 0.5 * self.h, 1, 2)

    -- foundation / roof
    love.graphics.setColor(10, 10, 10)
    love.graphics.rectangle("fill", self.x - self.w * 0.5, self.y, self.w, 0.1)
    love.graphics.rectangle("fill", self.x - self.w * 0.5, self.y - self.h, self.w, 0.1)

    -- walls
    love.graphics.rectangle("fill", self.x - self.w / 2 - 0.05, self.y - self.h, 0.1, self.h)
    love.graphics.rectangle("fill", self.x + self.w / 2 - 0.05, self.y - self.h, 0.1, self.h)

    --if self.h > 1 then
    --    love.graphics.setColor(57, 57, 57)
    --    love.graphics.rectangle("fill", self.x - self.w / 2, self.y - self.h + 0.15, self.w, self.h - 1)
    --end

    -- draw outline
    -- love.graphics.setColor(255, 0, 0)
    -- love.graphics.rectangle("line", self.x - self.w * 0.5, self.y - self.h + 0.15, self.w, self.h)
end

function Room:addNavNode(node)
    table.insert(self.group.navmesh, node)
    table.insert(self.navnodes, node)
end

function Room:addDoor(door)
    self.group:add(door)
    table.insert(self.doors, door)
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
            -- same level
            if v.x + v.w == self.x then
                -- left of this
                self.leftNode:connect(v.rightNode)
                self:addDoor(Door(self, v))
            end

            if self.x + self.w == v.x then
                -- right of this
                self.rightNode:connect(v.leftNode)
                self:addDoor(Door(self, v))
            end
        end
    end
end

function Room:onRemove(group) 
    for k, n in pairs(self.navnodes) do
        n:destroy()
    end

    for k, d in pairs(self.doors) do
        self.group:remove(d)
    end
end
