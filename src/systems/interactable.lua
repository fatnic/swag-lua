local InteractableSystem = tiny.processingSystem(class('InteractableSystem'))

InteractableSystem.filter = tiny.requireAll('interactive')

function InteractableSystem:process(e, dt)

    if e:selected() then
        if e:withinRange(World.characters.player) and e:isLineOfSight(World.characters.player) then
            if love.mouse.isDown(1) then e:activate() end
        end
    end

end

return InteractableSystem
