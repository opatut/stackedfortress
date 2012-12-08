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

function NavNode:distanceTo(other)
    local dx, dy = self.x - other.x, self.y - other.y
    return math.sqrt(dx * dx + dy * dy)
end

-- path finding algorithm
-- returns (pathLength, {nextNode, intermediateNode1, ..., targetNode})
function NavNode:findPath(target, visited)
    local visited = visited or {}

    if self == target then
        return {0, {self}}
    end

    if table.containsValue(self.connections, target) then
        return {self:distanceTo(target), {target}}
    end

    -- find the best path, but don't come check any already visited node
    local paths = {}
    local forbidden = table.join(visited, self.connections)
    for key, node in pairs(self.connections) do
        -- don't visit any node twice
        if not table.containsValue(visited, node) then
            local path = node:findPath(target, forbidden)
            if path[1] ~= -1 then -- found a valid path
                -- add the current node to the path
                if path[2][1] then
                    path[1] = path[1] + node:distanceTo(path[2][1])
                end
                path[2] = table.join({node}, path[2])
                table.insert(paths, path)
            end
        end
    end
    
    -- maybe there is no valid path...
    if #paths == 0 then 
        return {-1, {}}
    end

    -- sort by path length (shortest first)
    table.sort(paths, function (a, b) return b[1] < a[1] end)

    return paths[1]
end