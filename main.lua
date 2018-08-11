_G.utils = require 'utils'
_G.class = require 'libs.middleclass'
_G.inspect = require 'libs.inspect'

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

_G.grid = {}
for i = 0, gridHeight - 1 do
    row = {}
    for j = 0, gridWidth - 1 do
        row[j] = 0
    end
    grid[i] = row
end

_G.hardDrop = false

local fallTimer = 0
local fallSpeed = 0.1

_G.colors = {
    {0.059, 0.608, 0.843}, -- IPiece
    {0.129, 0.255, 0.776}, -- JPiece
    {0.890, 0.357, 0.008}, -- LPiece
    {0.890, 0.624, 0.008}, -- OPiece
    {0.349, 0.694, 0.004}, -- SPiece
    {0.843, 0.059, 0.216}, -- ZPiece
    {0.686, 0.161, 0.541}, -- TPiece
    {0.784, 0.784, 0.784}  -- Garbage blocks
}

require 'pieces'

local currentPiece = nil

function newPiece()
    -- currently only a tpiece for testing
    currentPiece = TPiece(4, 0)
end

newPiece()

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

    currentPiece:draw()

    -- drawing the grid
    love.graphics.setColor(1, 1, 1)
    for i = 0, gridHeight - 1 do
        for j = 0, gridWidth - 1 do
            if grid[i][j] ~= 0 then
                love.graphics.setColor(colors[grid[i][j]])
                love.graphics.rectangle('fill', j * tileSize + gridStartX, i * tileSize + gridStartY, tileSize, tileSize)
            end
        end
    end

    if displayDebug then
        if rainbowMode and rainbowModeColor then love.graphics.setColor(rainbowModeColor)
        else love.graphics.setColor(1, 1, 1, 0.9) end
        love.graphics.print('render options:'..'\n'..
            'gridy size: '..gridHeight..'\n'..
            'gridx size: '..gridWidth..'\n'..
            'tile size: '..tileSize..'\n'..
            'misc variables and such:'..'\n'..
            'width: '..width..'\n'..
            'height: '..height..'\n'..
            'block x: '..currentPiece.x..'\n'..
            'block y: '..currentPiece.y..'\n'..
            'press r to reset')
    end
end

function love.update(dt)
    fallTimer = fallTimer + dt
    if fallTimer > fallSpeed then
        fallTimer = 0
        if not currentPiece:update() then
            newPiece()
        end
        clearLines()
    end

    if rainbowMode then
        rainbowModeTimer = (rainbowModeTimer + dt) % 1
        rainbowModeColor = {utils.hslToRgb(rainbowModeTimer, .5, .5, 1)}
    end
end

function love.keypressed(key)
    if key == 'f3' then
        displayDebug = not displayDebug
    end
    if key == 'down' then
        fallSpeed = fallSpeed / 2
    end
    if key == 'x' then
        currentPiece:rotate()
    end
    if key == 'up' then
        hardDrop = true
    end
    -- reset key
    if key == 'r' then
        newPiece()
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
        fallSpeed = fallSpeed * 2
    end
end


function clearLines()
    for i = 0, gridHeight - 1 do
        row = grid[i]
        complete = true
        for k, v in pairs(row) do
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