local Piece = class('Piece')

function Piece:initialize(x, y, type, size)
    self.x = x
    self.y = y
    self.type = type
    self.size = size
    self.grid = {}
    for i = 1, self.size do
        row = {}
        for j = 1, self.size do
            row[j] = 0
        end
        self.grid[i] = row
    end
end

function Piece:draw()
    love.graphics.setColor(colors[self.type])
    for i = 1, self.size do
        for j = 1, self.size do
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
    startX = 1
    endX = self.size
    if love.keyboard.isDown('right') then
        reverse = true
        inc = 1
        startX = self.size
        endX = 0
    end

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        for y = 1, self.size do
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
    for y = 1, self.size do
        row = self.grid[y]
        for x = 1, self.size do
            if row[x] ~= 0 then
                if yOff + y + 1 >= gridHeight or grid[yOff + y + 1][self.x + x] ~= 0 then
                    return true
                end
            end
        end
    end
end

function Piece:toGrid()
    for i = 1, self.size do
        for j = 1, self.size do
            if grid[j][i] ~= 0 then
                grid[self.y + j][self.x + i] = self.type
            end
        end
    end
end



return Piece