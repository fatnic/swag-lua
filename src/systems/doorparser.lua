local DoorParserSystem = tiny.system(class('DoorParserSystem'))

function DoorParserSystem:initialize()
    World.doors = {}

    local doors = World.map.layers['doors'].objects

    for _, d in pairs(doors) do
        local orientation = tools.ternary(d.width > d.height, 'horizontal', 'vertcal')
        local door = Door:new(d.x, d.y, orientation)
        table.insert(World.doors, door)
        World.ecs:addEntity(door)

        local doorinteractive = RectangleInteractable:new(d.x, d.y, d.width, d.height, 'toggle_door-' .. door.uuid)
        World.ecs:addEntity(doorinteractive)
    end
end

return DoorParserSystem
