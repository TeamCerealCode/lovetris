local Piece = class('Piece')

function Piece:initialize(x, y, type, size)
    self.x = x
    self.y = y
    self.type = type
    self.size = size
    self.grid = {}
    -- start at 1 then go to size
    -- or start at 0 then go to size-1 ???
    for i = 0, self.size-1 do
        row = {}
        for j = 0, self.size-1 do
            row[j] = 0
        end
        self.grid[i] = row
    end
end

function Piece:draw()
    love.graphics.setColor(colors[self.type])
    -- same thing as the first one
    for i = 0, self.size-1 do
        for j = 0, self.size-1 do
            if self.grid[j][i] ~= 0 then
                love.graphics.rectangle('fill', (self.x + i) * tileSize + gridStartX, (self.y + j) * tileSize + gridStartY, tileSize, tileSize)
            end
        end
    end
end

function Piece:update()
    self:move()
    if self:collide() then
        self:toGrid()
        return false
    end

    self.y = self.y + 1
    return true
end

function Piece:move()
    reverse = false
    inc = -1
    -- start at 0 or 1??
    startX = 0
    -- end at size or size -1 ????
    -- no one knows .
    endX = self.size - 1
    if love.keyboard.isDown('right') then
        reverse = true
        inc = 1
        startX = self.size - 1
        endX = 0
    end

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        for y = 0, self.size-1 do
            row = self.grid[y]
            for x = startX, endX, inc * -1 do
                if row[x] ~= 0 then
                    if grid[self.y + y][self.x + x + inc] == 0 then
                        break
                    else 
                        return
                    end
                end
            end
        end
        self.x = self.x + inc
    end
end

function Piece:collide(yOff)
    yOff = yOff or self.y
    -- same as start
    for y = 0, self.size - 1 do
        row = self.grid[y]
        for x = 0, self.size - 1 do
            if row[x] ~= 0 then
                if yOff + y + 1 >= gridHeight or grid[yOff + y + 1][self.x + x] ~= 0 then
                    return true
                end
            end
        end
    end
end

function Piece:toGrid()
    -- you already know
    for i = 0, self.size - 1 do
        for j = 0, self.size - 1 do
            if grid[j][i] ~= 0 then
                grid[self.y + j][self.x + i] = self.type  
            end
        end
    end
end



return Piece