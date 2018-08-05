-- variables n stuff
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local displaydebug = false
local windowcenterx = width / 2
local windowcentery = height / 2

local tilesize = 20

local gridxsize = 10
local gridysize = 20

-- grid made the size of the window (dont actually use in final code, just a little fun script)
-- gridysize = math.floor(height/tilesize)
-- gridxsize = math.floor(width/tilesize)

-- make the grid variable
local gridx = {}
local gridy = {}
for n = 0, gridxsize-1, 1 do
    table.insert(gridx, #gridx+1, "empty")
end
for n = 0, gridysize-1, 1 do
    table.insert(gridy, #gridy+1, gridx)
end

function love.draw()
    -- grid draw
    love.graphics.setColor(1, 1, 1)
    for n = 0, tilesize * gridxsize, tilesize do
        love.graphics.line(windowcenterx - tilesize * gridxsize / 2 + n, windowcentery - tilesize * gridysize / 2, windowcenterx - tilesize * gridxsize / 2 + n, windowcentery + tilesize * gridysize / 2)
    end
    for i = 0, tilesize * gridysize, tilesize do
        love.graphics.line(windowcenterx - tilesize * gridxsize / 2, windowcentery - tilesize * gridysize / 2 + i, windowcenterx + tilesize * gridxsize / 2, windowcentery - tilesize * gridysize / 2 + i)
    end

    -- debug menu. use if you want to test something instead of littering code !!!!
    if displaydebug then
        love.graphics.setColor(1, 1, 1, 0.9) 
        love.graphics.print('render options:')
        love.graphics.print('gridy size: '..gridysize, 0, 15) 
        love.graphics.print('gridx size: '..gridxsize, 0, 30) 
        love.graphics.print('tile size: '..tilesize, 0, 45)
        love.graphics.print('misc variables and such:', 0, 60) 
        love.graphics.print('width: '..width, 0, 75) 
        love.graphics.print('height: '..height, 0, 90) 
    end
end

function love.update(dt)

end

function love.keypressed(key)
    -- debug menu
    if key == 'f3' then
        displaydebug = not displaydebug
    end
end

function love.resize(w, h) 
    width = w 
    height = h 
    windowcenterx = width / 2 
    windowcentery = height / 2 
end