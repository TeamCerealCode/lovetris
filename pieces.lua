local class = require 'middleclass'

local OBlock = class("OBlock")

function OBlock:initialize(x,y) 
   self.x = x
   self.y = y
end

function OBlock:draw()
    love.graphics.setColor(0.93, 0.95, 0.25)
    love.graphics.rectangle("fill",self.x*tilesize+gridstartx,self.y*tilesize+gridstarty,tilesize*2,tilesize*2)
end

function OBlock:update()
    self:move()
    if self.y + 2 >= gridheight then
        self:toGrid()
        return false
    end
    if grid[self.y + 2][self.x] ~= 0 or grid[self.y + 2][self.x + 1] ~= 0 then
        self:toGrid()
        return false
    end

    self.y = self.y + 1
    return true
end

function OBlock:toGrid()
    grid[self.y][self.x] = 4
    grid[self.y+1][self.x] = 4
    grid[self.y+1][self.x+1] = 4
    grid[self.y][self.x+1] = 4
end

function OBlock:move()
    if love.keyboard.isDown("left") then
        if self.x > 0 and grid[self.y][self.x - 1] == 0 and grid[self.y + 1][self.x - 1] == 0 then
            self.x = self.x - 1
        end
    end
    if love.keyboard.isDown("right") then
        if self.x < gridwidth - 2 and grid[self.y][self.x + 2] == 0 and grid[self.y + 1][self.x + 2] == 0 then
            self.x = self.x + 1
        end
    end
end

return OBlock