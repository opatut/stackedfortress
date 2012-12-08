Menu = class("Menu")
function Menu:__init(entries, callback)
    self.entries = entries or {}
    self.fade = 0
    self.current = 1
    self.callback = callback or function() end
    self.shown = false
    self.finishedCallback = nil

    self.fadeInTime = 0.3
    self.fadeOutTime = 0.3
end

function Menu:next()
    if not self.shown then return end
    self.current = self.current + 1
    if self.current > #self.entries then self.current = 1 end
end

function Menu:previous()
    if not self.shown then return end
    self.current = self.current - 1
    if self.current < 1 then self.current = #self.entries end
end

function Menu:trigger()
    if not self.shown then return end
    self.callback(self.current, self.entries[self.current])
end

function Menu:show(callback)
    self.shown = true
    self.finishedCallback = callback or nil
end

function Menu:hide(callback)
    self.shown = false
    self.finishedCallback = callback or nil
end

function Menu:isVisible()
    return self.fade > 0
end

function Menu:update(dt)
    -- fading in and out if necessary
    if self.shown and self.fade < 1 then
        self.fade = self.fade + dt / self.fadeInTime
        if self.fade > 1 then
            self.fade = 1
            if self.finishedCallback then self.finishedCallback() end
        end
    end

    if not self.shown and self.fade > 0 then
        self.fade = self.fade - dt / self.fadeOutTime
        if self.fade < 0 then
            self.fade = 0
            if self.finishedCallback then self.finishedCallback() end
        end
    end
end

function Menu:draw(x, y)
    -- don't draw if not visible
    if not self:isVisible() then return end

    maxWidth = 0
    for k,w in pairs(self.entries) do
        width = love.graphics.getFont():getWidth(w)
        if width > maxWidth then maxWidth = width end
    end

    fadeOffset = 0.4 -- this if the part for the offset, the rest is for moving each
    fadeSplit = fadeOffset / #self.entries
    fadeFirst = self.fade / (1 - fadeOffset) -- the first is finished at fade = 0.5, so at the end the value should be 2
    for k,w in pairs(self.entries) do
        love.graphics.setColor(255, 255, 255, self.current == k and 255 or 128)
        love.graphics.print(w, curves.sin(-maxWidth, x, fadeFirst - (k - 1) * fadeSplit / (1 - fadeOffset)), y + k * 35)
    end
end
