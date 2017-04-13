local VisionSystem = tiny.processingSystem(class('VisionSystem'))

VisionSystem.filter = tiny.requireAll('hasVision')

function VisionSystem:onAdd(entity)

end

function VisionSystem:process(e, dt)

end

return VisionSystem
