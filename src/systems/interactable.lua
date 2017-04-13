local InteractableSystem = tiny.processingSystem(class('InteractableSystem'))

InteractableSystem.filter = tiny.requireAll('interactive')

function InteractableSystem:process(e, dt)

    if e:selected() then
        World.mouse.hovering = true
        if e:withinRange(World.characters.player) and e:isLineOfSight(World.characters.player) then
            World.mouse.usable = true
            if love.mouse.isDown(1) then e:activate() end
        else
            World.mouse.usable = false
        end
    end

end

return InteractableSystem
