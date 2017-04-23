local LightingSystem = tiny.system(class('LightingSystem'))

function LightingSystem:initialize()
    World.lights = LightWorld({ambient = {140, 140, 140}})
    World.lights:setShadowBlur(1)
    
    for _, wall in pairs(World.walls) do
        World.lights:newRectangle(wall.x + wall.width / 2, wall.y + wall.height / 2, wall.width, wall.height)
    end

    for _, door in pairs(World.doors) do
        door.shadow = World.lights:newPolygon(door.body:getWorldPoints(door.shape:getPoints()))
    end
end

function LightingSystem:update(dt)
    for _, door in pairs(World.doors) do
        door.shadow:setPoints(door.body:getWorldPoints(door.shape:getPoints()))
    end

    World.lights:update(dt)
end

return LightingSystem
