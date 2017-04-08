local LookAtSystem = tiny.processingSystem(class('LookAtSystem'))

LookAtSystem.filter = tiny.requireAll('position', 'target')

function LookAtSystem:process(e, dt)
    e.rotation = math.atan2(e.target.y - e.position.y, e.target.x - e.position.x)
end

return LookAtSystem

