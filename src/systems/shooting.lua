local ShootingSystem = tiny.processingSystem(class('ShootingSystem'))

ShootingSystem.filter = tiny.requireAll('canshoot')

function ShootingSystem:initialize()
    World.shots = {}
end

function ShootingSystem:onAdd(entity)
    entity.shotTimer    = 0
    entity.shotInterval = 0.45
end

function ShootingSystem:process(e, dt)

    e.shotTimer = math.max(0, e.shotTimer - dt)

    if e.firing and e.shotTimer == 0 then

        assets.sounds.pistol:play({ pitch = 1.4 })

        local angle  = e.body:getAngle()
        local ex, ey = e.body:getPosition()
        local dx = math.cos(angle) 
        local dy = math.sin(angle)

        local hit = {}
        World.physics:rayCast(ex, ey, ex + dx * 1000, ey + dy * 1000, function(fixture, x, y, nx, ny, fraction) 
            hit = { x = x, y = y, fixture = fixture }
            return fraction
        end)
        hit.dx = dx
        hit.dy = dy

        local bulletforce = 50
        local udata = hit.fixture:getUserData()
        if udata then

            if udata.identifier == 'enemy'  then 
                local enemy = World.characters.enemies[udata.uuid]
                enemy.stunTimer = 2
                enemy.body:applyLinearImpulse(hit.dx * bulletforce, hit.dy * bulletforce)
            end

            if udata.identifier == 'wall'   then print('you hit a wall') end
            if udata.identifier == 'window' then print('you hit a window') end
            if udata.identifier == 'door'   then print('you hit a door') end
        end

        table.insert(World.shots, hit)

        e.shotTimer = e.shotInterval
    end

end

return ShootingSystem
