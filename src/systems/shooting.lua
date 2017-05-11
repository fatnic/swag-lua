local ShootingSystem = tiny.processingSystem(class('ShootingSystem'))

ShootingSystem.filter = tiny.requireAll('canshoot')

function ShootingSystem:initialize()
    World.shots = {}
end

function ShootingSystem:process(e, dt)

    if e.firing and e.cooldown == 0 then

        e.cooldown = 10
        e.firing = false

        local angle  = e.body:getAngle()
        local ex, ey = e.body:getPosition()
        local dx = ex + math.cos(angle) * 1000
        local dy = ey + math.sin(angle) * 1000

        local hit = {}
        World.physics:rayCast(ex, ey, dx, dy, function(fixture, x, y, nx, ny, fraction) 
            hit = { x = x, y = y, fixture = fixture }
            return fraction
        end)

        local udata = hit.fixture:getUserData()
        if udata and udata.identifier == 'enemy' then
            print('you hit enemy ' .. udata.uuid)
        end

        table.insert(World.shots, hit)
    end

    if e.cooldown > 0 then e.cooldown = e.cooldown - 1 end

end

return ShootingSystem
