local Piece = class('Piece')

function Piece:initialize(x, y, type, size)
    self.x = x
    self.y = y
    self.type = type
    self.size = size
    self.grid = {}
    self.slideTimer = 0
    self.fall = true
    self.rotation = 1

    for i = 1, self.size do
        row = {}
        for j = 1, self.size do
            row[j] = 0
        end
        self.grid[i] = row
    end
end

function Piece:draw(out, xOff, yOff, isGhost)
    if isGhost then
        for y = self.y, gridHeight do
            if self:collide(0, -self.y + y + 1) then
                yOff = yOff + (y - 1) * tileSize
                print(yOff)
                break
            end
        end

        local color = utils.copyTable(colors[self.type])
        color[4] = 0.5
        love.graphics.setColor(color)
    else
        love.graphics.setColor(colors[self.type])
    end

    for j = 1, self.size do
        y = j - 1
        for i = 1, self.size do
            x = i - 1
            if self.grid[j][i] ~= 0 then
                if out then
                    love.graphics.rectangle('fill', xOff + (i * tileSize), yOff + (j * tileSize), tileSize, tileSize)
                else
                    love.graphics.rectangle('fill', (self.x + x) * tileSize + gridStartX, (self.y + y) * tileSize + gridStartY, tileSize, tileSize)
                end
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

    if self:collide(0, 1) then
        self.slideTimer = self.slideTimer + dt * 100
        self.fall = false
    else
        self.fall = not (self.slideTimer > 0)
    end
        
    if self.slideTimer > 1 then
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

function Piece:collide(xOffset, yOffset)
    xOffset = (self.x + xOffset) or self.x
    yOffset = (self.y + yOffset) or self.y

    for j = 1, self.size do
        y = j - 1
        for i = 1, self.size do
            x = i - 1
            if self.grid[j][i] ~= 0 then
                if yOffset + y >= gridHeight or xOffset + x >= gridWidth or xOffset + x >= gridWidth or grid[yOffset + y][xOffset + x] ~= 0 then
                    return true
                end
            end
        end
    end
end

function Piece:rotate(direction)
    if self.type == 4 then return end

    local oldGrid = utils.copyTable(self.grid)
    local newGrid = {}

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
    self.slideTimer = 0
    
    local kicked = false

    for _, offsets in ipairs(wallkicks[self.type][self.rotation][direction]) do
        if not self:collide(offsets[1], offsets[2]) then
            kicked = true
            self.x = self.x + offsets[1]
            self.y = self.y + offsets[2]
            break
        end
    end

    if not kicked then
        self.grid = oldGrid
        return
    end

    if direction == 'ccw' then
        self.rotation = self.rotation - 1
        if self.rotation == 0 then self.rotation = 4 end
    elseif direction == 'cw' then
        self.rotation = (self.rotation + 1) % 5
        if self.rotation == 0 then self.rotation = 1 end
    end
end

function Piece:hardDrop()
    for y = self.y, gridHeight do
        if self:collide(0, -self.y + y + 1) then
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