-- variables n stuff
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local displaydebug = false
local windowcenterx = width/2
local windowcentery = height/2

-- set default launch things like title etc
love.window.setTitle("lovetris")


function love.draw()
    -- grid draw
    love.graphics.setColor(1,1,1,1)
    local n = 0
    while n<220 do
        love.graphics.line(windowcenterx-100+n, windowcentery-200, windowcenterx-100+n, windowcentery+200)
        n = n + 20
    end
    local i = 0
    while i<420 do
        love.graphics.line(windowcenterx-100, windowcentery-200+i, windowcenterx+100, windowcentery-200+i)
        i = i + 20
    end

    -- debug menu. use if you want to test something instead of littering code !!!!
    if displaydebug then
        love.graphics.setColor(1,1,1,0.9)
        --note to self: tostring()
        love.graphics.print('nothing atm', 0, 0) 
    end
end

function love.update(dt)

end

function love.keypressed(key,scancode,isrepeat)
    -- debug menu
    if key == 'f3' then
        if displaydebug then displaydebug = false else displaydebug = true end
    end
end