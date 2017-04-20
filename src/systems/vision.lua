local VisionSystem = tiny.processingSystem(class('VisionSystem'))

VisionSystem.filter = tiny.requireAll('hasvision')

function VisionSystem:onAdd(e)
    e.light = World.lights:newLight(e.x, e.y, 155, 155, 50, 300)
    e.light:setAngle(math.rad(70))
    e.light:setDirection(e.heading)
end

function VisionSystem:process(e, dt)
    e.light:setPosition(e.x, e.y)
    e.light:setDirection(e.heading)
end

return VisionSystem
