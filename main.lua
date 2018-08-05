-- variables n stuff
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local displaydebug = false
local windowcenterx = width / 2
local windowcentery = height / 2
<<<<<<< HEAD

local tilesize = 20

local gridxsize = 10
local gridysize = 20

-- grid made the size of the window (dont actually use in final code, just a little fun script)
-- gridysize = math.floor(height/tilesize)
-- gridxsize = math.floor(width/tilesize)

-- make the grid variable
local gridx = {}
local gridy = {}
local n = 0
for n = 0, gridxsize-1, 1 do
    table.insert(gridx, #gridx+1, "empty")
end
n = 0
for n = 0, gridysize-1, 1 do
    table.insert(gridy, #gridy+1, gridx)
end
=======
>>>>>>> master

function love.draw()
    -- grid draw
    love.graphics.setColor(1, 1, 1, 1)
<<<<<<< HEAD
    for n = 0, tilesize * gridxsize, tilesize do
        love.graphics.line(windowcenterx - tilesize * gridxsize / 2 + n, windowcentery - tilesize * gridysize / 2, windowcenterx - tilesize * gridxsize / 2 + n, windowcentery + tilesize * gridysize / 2)
    end
    for i = 0, tilesize * gridysize, tilesize do
        love.graphics.line(windowcenterx - tilesize * gridxsize / 2, windowcentery - tilesize * gridysize / 2 + i, windowcenterx + tilesize * gridxsize / 2, windowcentery - tilesize * gridysize / 2 + i)
=======
	for n = 1, 220, 20 do
        love.graphics.line(windowcenterx-100+n, windowcentery-200, windowcenterx-100+n, windowcentery+200)
    end
	for n = 1, 420, 20 do
        love.graphics.line(windowcenterx-100, windowcentery-200+n, windowcenterx+100, windowcentery-200+n)
>>>>>>> master
    end

    -- debug menu. use if you want to test something instead of littering code !!!!
    if displaydebug then
<<<<<<< HEAD
        love.graphics.setColor(1, 1, 1, 0.9) 
        -- note to self: tostring()
        love.graphics.print('render options:')
        love.graphics.print('gridy size: '..tostring(gridysize), 0, 15) 
        love.graphics.print('gridx size: '..tostring(gridxsize), 0, 30) 
        love.graphics.print('tile size: '..tostring(tilesize), 0, 45)
        love.graphics.print('misc variables and such:', 0, 60) 
        love.graphics.print('none', 0, 75) 
=======
        love.graphics.setColor(1, 1, 1, 0.9)
        -- note to self: tostring()
        love.graphics.print('nothing atm') 
>>>>>>> master
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

<<<<<<< HEAD
function love.resize(w, h) 
    width = w 
    height = h 
    windowcenterx = width / 2 
    windowcentery = height / 2 
=======
function love.resize(w, h)
    width = w
    height = h
    windowcenterx = width / 2
    windowcentery = height / 2
>>>>>>> master
end