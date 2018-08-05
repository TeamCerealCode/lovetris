-- variables n stuff
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local displaydebug = false
local windowcenterx = width / 2
local windowcentery = height / 2

function love.draw()
    -- grid draw
    love.graphics.setColor(1, 1, 1, 1)
	for n = 1, 220, 20 do
        love.graphics.line(windowcenterx-100+n, windowcentery-200, windowcenterx-100+n, windowcentery+200)
    end
	for n = 1, 420, 20 do
        love.graphics.line(windowcenterx-100, windowcentery-200+n, windowcenterx+100, windowcentery-200+n)
    end

    -- debug menu. use if you want to test something instead of littering code !!!!
    if displaydebug then
        love.graphics.setColor(1, 1, 1, 0.9)
        -- note to self: tostring()
        love.graphics.print('nothing atm') 
    end
end

function love.update(dt)
end

function love.keypressed(key, scancode, isrepeat)
    -- debug menu
    if key == 'f3' then
        if displaydebug then displaydebug = false else displaydebug = true end
    end
end
