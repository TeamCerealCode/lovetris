_G.utils = require 'utils'
_G.class = require 'libs.middleclass'

-- variables n stuff
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local displayDebug = false
local windowCenterX = width / 2
local windowCenterY = height / 2

local rainbowMode = false
local rainbowModeTimer = 0
local rainbowModeColor


_G.tileSize = 20

_G.gridWidth = 10
_G.gridHeight = 20

_G.gridStartX = windowCenterX - tileSize * gridWidth / 2
_G.gridStartY = windowCenterY - tileSize * gridHeight / 2

-- grid made the size of the window (dont actually use in final code, just a little fun script)
-- gridHeight = math.floor(height/tileSize)
-- gridWidth = math.floor(width/tileSize)

-- make the grid variable
_G.grid = {}
for i = 0, gridHeight - 1 do
    row = {}
    for j = 0, gridWidth - 1 do
        row[j] = 0
    end
    grid[i] = row
end

local tickt = 0
_G.fallSpd = 0.1

local OBlock = require 'pieces'

local currentBlock = OBlock(4, 0)

function love.load()
end

function love.draw()
    -- grid draw
    love.graphics.setColor(1, 1, 1)
    for n = 0, tileSize * gridWidth, tileSize do
        love.graphics.line(windowCenterX - tileSize * gridWidth / 2 + n, windowCenterY - tileSize * gridHeight / 2, windowCenterX - tileSize * gridWidth / 2 + n, windowCenterY + tileSize * gridHeight / 2)
    end
    for i = 0, tileSize * gridHeight, tileSize do
        love.graphics.line(windowCenterX - tileSize * gridWidth / 2, windowCenterY - tileSize * gridHeight / 2 + i, windowCenterX + tileSize * gridWidth / 2, windowCenterY - tileSize * gridHeight / 2 + i)
    end

    currentBlock:draw()

    -- drawing the grid
    love.graphics.setColor(1, 1, 1)
    for i = 0, gridHeight - 1 do
        for j = 0, gridWidth - 1 do
            if grid[i][j] ~= 0 then
                if grid[i][j] == 4 then love.graphics.setColor(0.93, 0.95, 0.25) end
                love.graphics.rectangle('fill', j * tileSize + gridStartX, i * tileSize + gridStartY, tileSize, tileSize)
            end
        end
    end

    -- debug menu. use if you want to test something instead of littering code !!!!
    if displayDebug then
        if rainbowMode and rainbowModeColor then love.graphics.setColor(rainbowModeColor)
        else love.graphics.setColor(1, 1, 1, 0.9) end
        love.graphics.print('render options:')
        love.graphics.print('gridy size: '..gridHeight, 0, 15)
        love.graphics.print('gridx size: '..gridWidth, 0, 30)
        love.graphics.print('tile size: '..tileSize, 0, 45)
        love.graphics.print('misc variables and such:', 0, 60)
        love.graphics.print('width: '..width, 0, 75)
        love.graphics.print('height: '..height, 0, 90)
        love.graphics.print('block x: '..currentBlock.x, 0, 105)
        love.graphics.print('block y: '..currentBlock.y, 0, 120)
        love.graphics.print('press r to reset', 0, 135)
    end
end

function love.update(dt)
    tickt = tickt + dt
    if tickt > fallSpd then
        tickt = 0
        if not currentBlock:update() then
            currentBlock = OBlock(3, 0)
        end
        clearLines()
    end

    if rainbowMode then
        rainbowModeTimer = (rainbowModeTimer + dt) % 1
        rainbowModeColor = {utils.hslToRgb(rainbowModeTimer, .5, .5, 1)}
    end
end

function love.keypressed(key)
    -- debug menu
    if key == 'f3' then
        displayDebug = not displayDebug
    end
    -- down
    if key == 'down' then
        fallSpd = fallSpd / 2
    end
    -- reset key
    if key == "r" then
        currentBlock = OBlock(3, 0)
        grid = {}
        for i = 0, gridHeight - 1 do
            row = {}
            for j = 0, gridWidth - 1 do
                row[j] = 0
            end
            grid[i] = row
        end
    end

    if key == 'f' and love.keyboard.isDown('f3') then
        rainbowMode = not rainbowMode
    end
end

function love.keyreleased(key)
    if key == 'down' then
        fallSpd = fallSpd * 2
    end
end


function clearLines()
    for i = 0, gridHeight - 1 do
        row = grid[i]
        complete = true 
        for k,v in pairs(row) do
            if v == 0 then
                complete = false
                break
            end
        end
        if complete then
            moveDown(i)
        end
    end
end

function moveDown(h)
    for i = h - 1, 0, -1 do
        grid[i + 1] = utils.copyTable(grid[i])
    end
    for i = 0, gridWidth - 1 do
        grid[0][i] = 0
    end

end

function love.resize(w, h) 
    tileSize = (width + height) / 70
    width = w 
    height = h 
    windowCenterX = width / 2 
    windowCenterY = height / 2 
    gridStartX = windowCenterX - tileSize * gridWidth / 2
    gridStartY = windowCenterY - tileSize * gridHeight / 2
end