local MouseFollowSystem = tiny.processingSystem(class('MouseFollowSystem'))

MouseFollowSystem.filter = tiny.requireAll('followmouse')

function MouseFollowSystem:process(e, dt)
    e.target = { x = World.mouse.x, y = World.mouse.y }
end

return MouseFollowSystem
