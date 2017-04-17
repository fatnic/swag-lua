local DoorParserSystem = tiny.system(class('DoorParserSystem'))

function DoorParserSystem:initialize()
    World.doors = {}

    local doors = World.map.layers['doors'].objects

    for _, d in pairs(doors) do
        local orientation = tools.ternary(d.width > d.height, 'horizontal', 'vertcal')
        local door = Door:new(d.x, d.y, orientation)
        table.insert(World.doors, door)
        World.ecs:addEntity(door)

        local offset = nil
        if orientation == 'horizontal' then
            offset1 = { x = -8, y = -1, r = 0} 
            offset2 = { x = 35, y = 16, r = 0} 
        else
            offset1 = { x = 17, y = -6, r = math.pi / 2} 
            offset2 = { x = 0,  y = 35, r = math.pi / 2} 
        end

        local bt1 = Sprite:new(d.x + offset1.x, d.y + offset1.y, assets.images.doorbutton_unlocked, 'fg', { rotation = offset1.r })
        World.ecs:addEntity(bt1)
        local bt2 = Sprite:new(d.x + offset2.x, d.y + offset2.y, assets.images.doorbutton_unlocked, 'fg', { rotation = offset2.r })
        World.ecs:addEntity(bt2)

        local button1 = CircleInteractable:new(bt1.center.x, bt1.center.y, 10, 'toggle_door-' .. door.uuid, { range = 25 })
        World.ecs:addEntity(button1)
        local button2 = CircleInteractable:new(bt2.center.x - 4, bt2.center.y + 3, 10, 'toggle_door-' .. door.uuid, { range = 25 })
        World.ecs:addEntity(button2)

    end
end

return DoorParserSystem
