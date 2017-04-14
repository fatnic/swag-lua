local DoorParserSystem = tiny.system(class('DoorParserSystem'))

function DoorParserSystem:initialize()
    World.doors = {}

    local doors = World.map.layers['doors'].objects

    for _, d in pairs(doors) do
        -- local d = Door:new(d.x, d.y, lume.uuid())
    end
end

return DoorParserSystem
