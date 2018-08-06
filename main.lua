-- variables n stuff
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local displaydebug = false
local windowcenterx = width / 2
local windowcentery = height / 2

_G.tilesize = 20

_G.gridwidth = 10
_G.gridheight = 20

_G.gridstartx = windowcenterx - tilesize * gridwidth / 2
_G.gridstarty = windowcentery - tilesize * gridheight / 2

-- grid made the size of the window (dont actually use in final code, just a little fun script)
-- gridheight = math.floor(height/tilesize)
-- gridwidth = math.floor(width/tilesize)

-- make the grid variable
_G.grid = {}
for i = 0, gridheight-1 do
    row = {}
    for j = 0, gridwidth-1 do
        row[j] = 0
    end
    grid[i] = row
end

local tickt = 0
_G.fallSpd = 0.1

local OBlock = require 'pieces'

local currentBlock = OBlock(3,0)


function love.load()
    -- make window resizable
    love.window.setMode(800, 600, {resizable=true, vsync=false, minwidth=450, minheight=510})
end

function love.draw()
    -- grid draw
    love.graphics.setColor(1, 1, 1)
    for n = 0, tilesize * gridwidth, tilesize do
        love.graphics.line(windowcenterx - tilesize * gridwidth / 2 + n, windowcentery - tilesize * gridheight / 2, windowcenterx - tilesize * gridwidth / 2 + n, windowcentery + tilesize * gridheight / 2)
    end
    for i = 0, tilesize * gridheight, tilesize do
        love.graphics.line(windowcenterx - tilesize * gridwidth / 2, windowcentery - tilesize * gridheight / 2 + i, windowcenterx + tilesize * gridwidth / 2, windowcentery - tilesize * gridheight / 2 + i)
    end

    currentBlock:draw()

    -- drawing the grid
    love.graphics.setColor(1, 1, 1)
    for i = 0, gridheight-1 do
        for j = 0, gridwidth-1 do
            if grid[i][j] ~= 0 then
                if grid[i][j] == 4 then love.graphics.setColor(0.93, 0.95, 0.25) end
                love.graphics.rectangle("fill",j*tilesize+gridstartx,i*tilesize+gridstarty,tilesize,tilesize)
            end
        end
    end

    -- debug menu. use if you want to test something instead of littering code !!!!
    if displaydebug then
        love.graphics.setColor(1, 1, 1, 0.9) 
        love.graphics.print('render options:')
        love.graphics.print('gridy size: '..gridheight, 0, 15) 
        love.graphics.print('gridx size: '..gridwidth, 0, 30) 
        love.graphics.print('tile size: '..tilesize, 0, 45)
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
            currentBlock = OBlock(3,0)
        end
        clearLines()
    end
end

function love.keypressed(key)
    -- debug menu
    if key == 'f3' then
        displaydebug = not displaydebug
    end
    -- down
    if key == 'down' then
        _G.fallSpd = _G.fallSpd/2
    end
    -- reset key
    if key == "r" then
        currentBlock = OBlock(3,0)
        grid = {}
        for i = 0, gridheight-1 do
            row = {}
            for j = 0, gridwidth-1 do
                row[j] = 0
            end
            grid[i] = row
        end
    end
end

function love.keyreleased(key)
    if key == 'down' then
        fallSpd = fallSpd*2
    end
end


function clearLines()
    for i = 0, gridheight-1 do
        row = grid[i]
        complete = true 
        for k,v in pairs(row) do
            if v == 0 then
                complete = false
                break
            end
        end
        if complete then
            movedown(i)
        end
    end
end

function movedown(h)
    for i = h-1, 0, -1 do
        grid[i + 1] = grid[i]
    end
    for i = 0, gridwidth-1 do
        grid[0][i] = 0
    end

end

function love.resize(w, h) 
    tilesize = (width + height) / 70
    width = w 
    height = h 
    windowcenterx = width / 2 
    windowcentery = height / 2 
    gridstartx = windowcenterx - tilesize * gridwidth / 2
    gridstarty = windowcentery - tilesize * gridheight / 2
end