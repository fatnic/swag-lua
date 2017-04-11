local InteractableSystem = tiny.processingSystem(class('InteractableSystem'))

InteractableSystem.filter = tiny.requireAll('interactive')

function InteractableSystem:process(e, dt)

    local x,y = World.mouse.x, World.mouse.y

    if ( x >= e.position.x and x <= e.position.x + e.width) and ( y >= e.position.y and y <= e.position.y + e.height ) then
        if love.mouse.isDown(1) then e:activate() end
    end
    -- if within radius
    -- if hovering
    -- if lineofisght
    -- e:activate()
end

return InteractableSystem
