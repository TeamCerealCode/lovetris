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

local maximized = false

local mode = 1
-- 1 - endless tetris
-- 2 - dig (cheese race)
-- 3 - dig extreme
-- 4 - sprint (multi)
-- multisprint records your time for each line possibility in the same match

local f3held = false

_G.tileSize = 20

_G.gridWidth = 10
_G.gridHeight = 20

_G.gridStartX = windowCenterX - tileSize * gridWidth / 2
_G.gridStartY = windowCenterY - tileSize * gridHeight / 2

_G.grid = nil

_G.hardDrop = false
_G.hasHeld = false

_G.paused = false
_G.gameEnded = false

_G.linesCleared = 0

local timer = 0
local sprinttimes = {}

local fallTimer = 0
local fallSpeed = 0.5

local arr = 0
local arrTimer = 0
local das = 133
local dasTimer = 0 
local dasMode = false

require 'pieces'

local currentPiece = nil
local bag = {}
local upcoming = {}
local hold = 0

function newBag()
    local pieces = {1,2,3,4,5,6,7}
    bag = utils.shuffle(pieces)
end

function newUpcoming()
    table.insert(upcoming,table.remove(bag,1))
    if #bag == 0 then
        newBag()
    end
end

function getUpcoming()
    newUpcoming()
    return table.remove(upcoming,1)
end

function newPiece(hld)
    local piece = nil
    if hld then
        hasHeld = true
        if hold == 0 then
            piece = getPiece(getUpcoming())
        else
            piece = getPiece(hold)
        end
    else
        piece = getPiece(getUpcoming())
    end
    currentPiece = piece(4, 0)
end

math.randomseed(os.time())
function love.load()

    paused = false
    gameEnded = false

    timer = 0
    sprinttimes = {0,0,0}
    linesCleared = 0

    grid = {}

    local heights = {}
    local currheight = 2
    for h = 0, gridHeight - 1 do
        currheight = currheight + math.ceil(math.random()*2-1)
        if currheight<1 then currheight = 1 end
        heights[h] = currheight
    end

    for i = 0, gridHeight - 1 do
        row = {}

        local randomHole = math.floor(math.random()*gridWidth)

        for j = 0, gridWidth - 1 do
            if mode == 1 then --regular
                row[j] = 0
            elseif mode == 2 then --dig
                if j == randomHole then
                    row[j] = 0
                else
                    row[j] = 8
                end
            elseif mode == 3 then --digextreme
                row[j] = (j+i%2)%2*8
            elseif mode == 4 then --sprint (multi)
                row[j] = 0
            end

            if i < gridHeight/2 and mode == 3 then
                row[j] = 0
            elseif i < math.floor(gridHeight/3) and mode == 2 then
                row[j] = 0
            end
            grid[i] = row
        end
    end

    bag = {}
    upcoming = {}
    hold = 0
    newBag()
    for i = 1, 5 do
        newUpcoming()
    end
    newPiece()
end

function love.draw()
    -- grid draw
    love.graphics.setColor(1, 1, 1, 0.25)
    love.graphics.setLineStyle("rough")
    for n = 0, tileSize * gridWidth, tileSize do
        love.graphics.line(windowCenterX - tileSize * gridWidth / 2 + n, windowCenterY - tileSize * gridHeight / 2, windowCenterX - tileSize * gridWidth / 2 + n, windowCenterY + tileSize * gridHeight / 2)
    end
    for i = 0, tileSize * gridHeight, tileSize do
        love.graphics.line(windowCenterX - tileSize * gridWidth / 2, windowCenterY - tileSize * gridHeight / 2 + i, windowCenterX + tileSize * gridWidth / 2, windowCenterY - tileSize * gridHeight / 2 + i)
    end

    currentPiece:draw()
    currentPiece:draw(true, (currentPiece.x - 1) * tileSize + gridStartX, gridStartY, true)

    -- drawing the grid
    love.graphics.setColor(1, 1, 1)
    if not paused and not gameEnded then
    for i = 0, gridHeight - 1 do
        for j = 0, gridWidth - 1 do
            if grid[i][j] ~= 0 then
                love.graphics.setColor(colors[grid[i][j]])
                love.graphics.rectangle('fill', j * tileSize + gridStartX, i * tileSize + gridStartY, tileSize, tileSize)
            end
        end
    end
    elseif paused and not gameEnded then
        love.graphics.print('paused - esc to unpause', gridStartX, gridStartY-20)
    else
        love.graphics.print('game over - press r to restart', gridStartX, gridStartY-20)
        love.graphics.setColor(0.5,0.5,0.5)
        for i = 0, gridHeight - 1 do
            for j = 0, gridWidth - 1 do
                if grid[i][j] ~= 0 then
                    love.graphics.rectangle('fill', j * tileSize + gridStartX, i * tileSize + gridStartY, tileSize, tileSize)
                end
            end
        end
    end

    -- drawing the upcoming pieces
    local y = gridStartY
    for i = 1, #upcoming do
        local cur = getPiece(upcoming[i])
        cur = cur(0,0)
        cur:draw(true, gridStartX + (gridWidth * tileSize) + tileSize, y)
        local s = cur.size
        if s <= 2 then s = 3 end
        y = y + s * tileSize
    end
    -- border around upcoming pieces
    love.graphics.setColor(1,1,1,0.5)
    love.graphics.line(gridStartX + gridWidth * tileSize, gridStartY, gridStartX + gridWidth * tileSize + 7 * tileSize, gridStartY)
    love.graphics.line(gridStartX + gridWidth * tileSize, gridStartY+3.5*tileSize, gridStartX + gridWidth * tileSize + 7 * tileSize, gridStartY+3.5*tileSize)
    love.graphics.line(gridStartX + gridWidth * tileSize + 7 * tileSize, gridStartY+3.5*tileSize, gridStartX + gridWidth * tileSize + 7 * tileSize, gridStartY)
    love.graphics.line(gridStartX + gridWidth * tileSize + tileSize, gridStartY+3.5*tileSize, gridStartX + gridWidth * tileSize + tileSize, gridStartY + #upcoming*3.5 * tileSize)
    love.graphics.line(gridStartX + gridWidth * tileSize + 6.5 * tileSize, gridStartY+3.5*tileSize, gridStartX + gridWidth * tileSize + 6.5 * tileSize, gridStartY + #upcoming*3.5 * tileSize)
    love.graphics.line(gridStartX + gridWidth * tileSize + tileSize, gridStartY + #upcoming*3.5 * tileSize, gridStartX + gridWidth * tileSize + 6.5 * tileSize, gridStartY + #upcoming*3.5 * tileSize)
    love.graphics.print('next', gridStartX + gridWidth * tileSize + 5, 5+gridStartY)

    -- drawing the currently held piece
    if hold ~= 0 then
        local holdP = getPiece(hold)
        holdP = holdP(0,0)
        holdP:draw(true, gridStartX - ((holdP.size + 2) * tileSize), gridStartY)
    end
    -- border around held piece
    love.graphics.setColor(1,1,1,0.5)
    love.graphics.line(gridStartX, gridStartY, gridStartX - 5*tileSize, gridStartY)
    love.graphics.line(gridStartX, gridStartY+4*tileSize, gridStartX - 5*tileSize, gridStartY+4*tileSize)
    love.graphics.line(gridStartX - 5*tileSize, gridStartY, gridStartX - 5*tileSize, gridStartY+4*tileSize)
    love.graphics.print('hold', gridStartX - 5*tileSize + 5, 5+gridStartY)

    -- stats
    if mode == 1 or mode == 4 then
        if mode == 1 then
            modestring = "Infinite Tetris"
        elseif mode == 4 then
            modestring = "Sprint (MultiLi)"
        end
        love.graphics.printf(modestring.."\n"..
        'lines cleared: '..linesCleared..'\n'..
        'timer: '..formatTime(timer)..'\n'..
        '20l time: '..formatTime(sprinttimes[1])..'\n'..
        '40l time: '..formatTime(sprinttimes[2])..'\n'..
        '100l time: '..formatTime(sprinttimes[3])..'\n', 
        gridStartX-260, gridStartY+gridHeight/4*tileSize, 250, 'right' 
        ) 
    elseif mode == 2 or mode == 3 then
        if mode == 2 then
            modestring = "Dig (Cheese Race)"
        elseif mode == 3 then
            modestring = "Dig Extreme"
        end
        love.graphics.printf(modestring..'\n'..
        'timer: '..formatTime(timer)..'\n'..
        'garbage blocks left: '..scanForGarbage()..'\n', 
        gridStartX-260, gridStartY+gridHeight/4*tileSize, 250, 'right' 
        ) 
    end
    


    --debug menu
    if displayDebug then
        if rainbowMode and rainbowModeColor then love.graphics.setColor(rainbowModeColor)
        else love.graphics.setColor(1, 1, 1, 0.9) end
        love.graphics.print('render options:'..'\n'..
            'gridy size: '..gridHeight..'\n'..
            'gridx size: '..gridWidth..'\n'..
            'tile size: '..tileSize..'\n'..
            'misc variables and such:'..'\n'..
            'timer: '..timer..'\n'..
            'mode: '..mode..'\n'..
            'width: '..width..'\n'..
            'height: '..height..'\n'..
            'block x: '..currentPiece.x..'\n'..
            'block y: '..currentPiece.y..'\n'..
            'block slide: '..currentPiece.slideTimer..'\n'..
            'press r to reset\n'..
            'f3 + m for mode change\n'..
            'f3 + e for force game end')
    end
end

function love.update(dt)
    if love.window.isMaximized() then
        if not maximized then
            maximized = true
            love.resize(love.graphics.getWidth(),love.graphics.getHeight())
        end
    elseif maximized then
        maximized = false
        love.resize(love.graphics.getWidth(),love.graphics.getHeight())
    end

    if not paused then timer = timer + dt end
    if not paused then
        if love.keyboard.isDown('right') or love.keyboard.isDown('left') then
            if dasMode == false then
                dasTimer = dasTimer + dt
                if dasTimer * 1000 > das then
                    dasMode = true
                end
            else
                arrTimer = arrTimer + dt
                if arrTimer * 1000 > arr then
                    if love.keyboard.isDown('right') then
                        currentPiece:move('right')
                    elseif love.keyboard.isDown('left') then
                        currentPiece:move('left')
                    end
                    arrTimer = 0
                end
            end
        else
           dasTimer = 0
            dasMode = false
        end

        fallTimer = fallTimer + dt
        if fallTimer > fallSpeed then
            if not currentPiece:update(fallTimer) then
                newPiece()
            end
            fallTimer = 0
        end

        clearLines()

    end

    if rainbowMode then
        rainbowModeTimer = (rainbowModeTimer + dt) % 1
        rainbowModeColor = {utils.hslToRgb(rainbowModeTimer, .5, .5, 1)}
    end
end

function love.keypressed(key)
    if key == 'f4' then
        love.load()
    elseif (key == 'left' or key == 'right') and not paused then
        currentPiece:move(key)
    elseif key == 'down' and not paused then
        fallSpeed = fallSpeed / 50
    elseif key == 'z' and not paused then
        currentPiece:rotate("ccw")
    elseif key == 'x' and not paused then
        currentPiece:rotate("cw")
    elseif (key == 'space' or key == 'up') and not paused then
        currentPiece:hardDrop()
        newPiece()
        clearLines()
    elseif key == 'c' then
        if not hasHeld then
            local t = currentPiece.type
            newPiece(true)
            hold = t
        end
    elseif key == 'r' then
        love.load()
    elseif key == 'f' and love.keyboard.isDown('f3') then
        rainbowMode = not rainbowMode
        f3held = true
    elseif key == 'm' and love.keyboard.isDown('f3') then
        f3held = true
        mode = mode + 1
        if mode == 5 then
            mode = 1
        end
        love:load()
    elseif key == 'escape' then
        pause()
    elseif key == 'e' and love.keyboard.isDown('f3') then
        f3held = true
        endGame()
    end
end

function love.keyreleased(key)
    if key == 'f3' then
        if not f3held then
            displayDebug = not displayDebug
        else
            f3held = false
        end
    elseif key == 'down' then
        fallSpeed = fallSpeed * 50
    end
    
end

function pause()
    if not gameEnded then
        paused = not paused
    end
end

function scanForGarbage() 
    local garbageAmount = 0
    for i = 0, gridHeight - 1 do
        for j = 0, gridWidth - 1 do
            if grid[i][j] == 8 then garbageAmount = garbageAmount + 1 end
        end
    end
    return garbageAmount
end

function endGame()
    pause()
    gameEnded = true
end

function formatTime(s)
    ms = math.floor(s*1000)
    s = math.floor(s)
    m = math.floor(s/60)
    
    ms = ms%1000
    s = s%60
    m = m%60

    mstring = m
    sstring = s
    msstring = ms


    if m < 10 then
        mstring = '0'..m..''
    end
    if s < 10 then
        sstring = '0'..s..''
    end
    if ms < 10 then
        msstring = '00'..ms..''
    elseif ms > 9 and ms < 100 then
        msstring = '0'..ms..''
    end

    return mstring ..':'.. sstring ..'.'.. msstring
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
            linesCleared = linesCleared + 1
            if mode == 4 then
                if linesCleared == 20 then
                    sprinttimes[1] = timer
                elseif linesCleared == 40 then
                    sprinttimes[2] = timer
                elseif linesCleared == 100 then
                    sprinttimes[3] = timer
                    endGame()
                end
            elseif mode == 3 or mode == 2 then
                if scanForGarbage() < 1 then
                    endGame()
                end
            end
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