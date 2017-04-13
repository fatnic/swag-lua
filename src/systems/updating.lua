local UpdatingSystem = tiny.processingSystem(class('UpdatingSystem'))

UpdatingSystem.filter = tiny.requireAll('updatable')

function UpdatingSystem:process(e, dt)
    e:update(dt)
end

return UpdatingSystem
