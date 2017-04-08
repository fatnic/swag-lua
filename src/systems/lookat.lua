local LookAtSystem = tiny.processingSystem(class('LookAtSystem'))

LookAtSystem.filter = tiny.requireAll('target')

function LookAtSystem:process(e, dt)
    local x, y = e.body:getX(), e.body:getY()
    local rotation = math.atan2(e.target.y - y, e.target.x - x)
    e.body:setAngle(rotation)
end

return LookAtSystem

