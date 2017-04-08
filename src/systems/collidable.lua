local CollidableSystem = tiny.processingSystem(class("CollidableSystem"))

CollidableSystem.filter = tiny.requireAll('position', 'width', 'height', 'collidable')

function CollidableSystem:onAdd(entity) 
    entity.hitbox = HC.rectangle(entity.position.x, entity.position.y, entity.width, entity.height)
    entity.hitbox:setRotation(entity.rotation)
end

function CollidableSystem:process(e, dt)
    e.hitbox:moveTo(e.position.x, e.position.y)
    e.hitbox:setRotation(e.rotation)

    for _, wall in pairs(World.walls) do
        if e.hitbox:collidesWith(wall.hitbox) then
        end
    end
end

return CollidableSystem
