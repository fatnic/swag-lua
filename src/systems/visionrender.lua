local VisionRenderSystem = tiny.processingSystem(class('VisionRenderSystem'))

VisionRenderSystem.filter = tiny.requireAll('hasvision')

function VisionRenderSystem:onAdd(e)
    e.fov = e.fov or 70
    e.viewdistance = e.viewdistance or 300
    e.light = World.lights:newLight(e.x, e.y, 255, 255, 255, e.viewdistance)
    e.light:setAngle(math.rad(e.fov))
    e.light:setDirection(e.heading)
end

function VisionRenderSystem:process(e, dt)
    e.light:setPosition(e.x, e.y)
    e.light:setDirection(e.heading)
end

return VisionRenderSystem
