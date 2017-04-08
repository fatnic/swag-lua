local MouseFollowSystem = tiny.processingSystem(class('MouseFollowSystem'))

MouseFollowSystem.filter = tiny.requireAll('followmouse')

function MouseFollowSystem:process(e, dt)
    local x, y = love.mouse:getX(), love.mouse:getY()
    e.target = { x = x, y = y }
end

return MouseFollowSystem
