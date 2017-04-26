local VisionSystem = tiny.processingSystem(class('VisionSystem'))

VisionSystem.filter = tiny.requireAll('hasvision')

function VisionSystem:onAdd(e)
    e.fov = e.fov or 60
    e.viewdistance = e.viewdistance or 300
    e.light = World.lights:newLight(e.x, e.y, 255, 255, 155, e.viewdistance)
    e.light:setAngle(math.rad(e.fov))
    e.light:setDirection(e.heading)
end

function VisionSystem:process(e, dt)
    e.light:setPosition(e.x, e.y)
    e.light:setDirection(e.heading)
    e.minFoV = e.heading - tools.normaliseRadian(math.rad(e.fov / 2))
    e.maxFoV = e.heading + tools.normaliseRadian(math.rad(e.fov / 2))

    local withinfov = false
    local withindistance = false
    local blocked = true

    local char = World.characters.player

    if tools.distance(char, e) < e.viewdistance then withindistance = true end

    for i=1, #char.hitpoints do
        local point = char.hitpoints[i]
        local pa = tools.normaliseRadian(math.atan2(point.y - e.y, point.x - e.x))
        if tools.isAngleBetween(pa, e.minFoV, e.maxFoV) then
            withinfov = true
            if tools.isLineOfSight(e, point) then blocked = false end
        end
    end

    if withinfov and withindistance and not blocked then 
        e.target = { x = char.x, y = char.y } 
    else
        e.target = e.target
    end
end

return VisionSystem
