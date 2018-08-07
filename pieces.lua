local Piece = require 'piece'

local OBlock = class('OBlock',Piece)

function OBlock:initialize(x,y)
    Piece.initialize(self,x,y,4,2)
    self.grid[0] = {1, 1}
    self.grid[1] = {1, 1}
end

function OBlock:update()
    self:move()
    if self.y + 2 >= gridHeight then
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

function OBlock:move()
    if love.keyboard.isDown('left') then
        if self.x > 0 and grid[self.y][self.x - 1] == 0 and grid[self.y + 1][self.x - 1] == 0 then
            self.x = self.x - 1
        end
    end
    if love.keyboard.isDown('right') then
        if self.x < gridWidth - 2 and grid[self.y][self.x + 2] == 0 and grid[self.y + 1][self.x + 2] == 0 then
            self.x = self.x + 1
        end
    end
end

return OBlock