local Piece = class('Piece')

function Piece:initialize(x, y, type, size)
    self.x = x
    self.y = y
    self.type = type
    self.size = size
    self.grid = {}
    for i = 1, self.size-1 do
        row = {}
        for j = 1, self.size-1 do
            row[j] = 0
        end
        self.grid[i] = row
    end
end

function Piece:draw()
    love.graphics.setColor(colors[self.type])
    for i = 0, self.size-1 do
        for j = 0, self.size-1 do
            love.graphics.rectangle('fill', (self.x + i) * tileSize + gridStartX, (self.y + j) * tileSize + gridStartY, tileSize, tileSize)
        end
    end
end

function Piece:move()
    reverse = false
    inc = -1
    sX = 0
    if love.keyboard.isDown('right') then
        reverse = true
        inc = 1
        sX = self.size - 1
    end

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        for y = 0, self.size-1 do
            for x = 0, self.size-1 do

            end
        end
    end
end

function Piece:toGrid()
    for i = 0, self.size-1 do
        for j = 0, self.size-1 do
            grid[self.y + j][self.x + i] = self.type  
        end
    end
end



return Piece