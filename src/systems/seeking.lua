local SeekingSystem = tiny.processingSystem(class('SeekingSystem'))

function SeekingSystem:process(e, dt)
    if e.seeking then
        local dx = tools.normalise(e.seeking.x - e.x) * e.speed
        local dy = tools.normalise(e.seeking.y - e.y) * e.speed
        local x, y = e.body:getLinearVelocity()
        local steering = { x = dx - x, y = dy - y }
        e.body:applyForce(steering.x, steering.y)
    end
end

return SeekingSystem
