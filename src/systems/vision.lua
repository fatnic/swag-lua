local VisionSystem = tiny.processingSystem(class('VisionSystem'))

VisionSystem.filter = tiny.requireAll('hasvision')

function VisionSystem:onAdd(e)
    e.viewable = {}
end

function VisionSystem:process(e, dt)

    local withinfov = false
    local withindistance = false
    local blocked = true

    local char = World.characters.player

    if tools.distance(char, e) < e.viewdistance then withindistance = true end

    local pa = tools.normaliseRadian(math.atan2(char.y - e.y, char.x - e.x))
    local minFoV = e.heading - tools.normaliseRadian(math.rad(e.fov / 2))
    local maxFoV = e.heading + tools.normaliseRadian(math.rad(e.fov / 2))
    if tools.isAngleBetween(pa, minFoV, maxFoV) then
        withinfov = true
        if tools.isLineOfSight(char, e) then blocked = false end
    end

    if withinfov and withindistance and not blocked then 
        e.target = { x = char.x, y = char.y } 
    else
        e.target = nil
    end

end

return VisionSystem
