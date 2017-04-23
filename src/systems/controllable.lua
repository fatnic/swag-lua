local ControllableSystem = tiny.processingSystem(class("ControllableSystem"))

ControllableSystem.filter = tiny.requireAll('controllable')

function ControllableSystem:initialize()
end

function ControllableSystem:process(e, dt)
    if World.input:down 'up'    then e:moveUp(dt) end
    if World.input:down 'down'  then e:moveDown(dt) end
    if World.input:down 'left'  then e:moveLeft(dt) end
    if World.input:down 'right' then e:moveRight(dt) end
end

return ControllableSystem
