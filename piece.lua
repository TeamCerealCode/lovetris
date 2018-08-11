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

    self.slideTimer = 0
    self.fall = true
end

function Piece:draw()
    love.graphics.setColor(colors[self.type])
    for j = 1, self.size do
        y = j - 1
        for i = 1, self.size do
            x = i - 1
            if self.grid[j][i] ~= 0 then
                love.graphics.rectangle('fill', (self.x + x) * tileSize + gridStartX, (self.y + y) * tileSize + gridStartY, tileSize, tileSize)
            end
        end
    end
end

function Piece:update(dt)
    self:move()
    if hardDrop then
        hardDrop = false
        self:hardDrop()
        return false
    end

    if self:collide() then
        self.slideTimer = self.slideTimer + dt * 1000
        self.fall = false
    else
        self.fall = not (self.slideTimer > 0)
    end
        
    if self.slideTimer > 60 then
        self:toGrid()
        return false
    end

    if self.fall then
        self.y = self.y + 1
    end
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
        endX = 1
    end

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        for j = 1, self.size do
            y = j - 1
            for i = startX, endX, inc * -1 do
                x = i - 1
                if self.grid[j][i] ~= 0 then
                    if grid[self.y + y][self.x + x + inc] == 0 then
                        break
                    else
                        return
                    end
                end
            end
        end
        self.x = self.x + inc
        self.slideTimer = 0
    end
end

function Piece:collide(yOffset)
    yOffset = yOffset or self.y
    for j = 1, self.size do
        y = j - 1
        for i = 1, self.size do
            x = i - 1
            if self.grid[j][i] ~= 0 then
                if yOffset + y + 1 >= gridHeight or grid[yOffset + y + 1][self.x + x] ~= 0 then
                    return true
                end
            end
        end
    end
end

function Piece:rotate(direction)
    oldGrid = utils.copyTable(self.grid)
    newGrid = {}

    for i = 1, self.size do
        row = {}
        for j = 1, self.size do
            row[j] = 0
        end
        newGrid[i] = row
    end

    for j = 1, self.size do
        for i = 1, self.size do
            if direction == "cw" then
                newGrid[i][self.size - j + 1] = self.grid[j][i]
            elseif direction == "ccw" then
                newGrid[self.size - i + 1][j] = self.grid[j][i]
            end
        end
    end

    self.grid = newGrid
    self.slideTimer = 0;
    
    if self:collide() then
        self.grid = oldGrid
    end
end

function Piece:hardDrop()
    for y = self.y, gridHeight do
        if self:collide(y) then
            self.y = y
            self:toGrid()
            return true
        end
    end
end

function Piece:toGrid()
    for i = 1, self.size do
        for j = 1, self.size do
            if self.grid[j][i] ~= 0 then
                grid[self.y + j - 1][self.x + i - 1] = self.type
            end
        end
    end
end



return Piece