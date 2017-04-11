local TileRendererSystem = tiny.system(class('TileRendererSystem'))

function TileRendererSystem:initialize(args)
    local args = args or {}
    World.walls = {}

    for _, layer in pairs(World.map.layers) do
        if layer.type == 'objectgroup' then layer.visible = false end
    end

    -- World.map.layers['walls'].visible = false

    local collisions = World.map.layers['collisions'].objects
    for _, c in pairs(collisions) do
        local wall = Wall.new(c.x, c.y, c.width, c.height)

        wall.body    = love.physics.newBody(World.physics, c.x + c.width / 2, c.y + c.height / 2)
        wall.shape   = love.physics.newRectangleShape(c.width, c.height)
        wall.fixture = love.physics.newFixture(wall.body, wall.shape)

        table.insert(World.walls, wall)
    end

    World.doors = {}
    local doors = World.map.layers['doors'].objects
    for _, d in pairs(doors) do
        local uuid = lume.uuid()

        local door1 = Door:new(d.x, d.y, uuid, 1)
        local door2 = Door:new(d.x + 24, d.y, uuid, 2)
        World.ecs:addEntity(door1)
        World.ecs:addEntity(door2)

        local inter1 = Interactable:new(d.x - 12, d.y - 3, assets.images.doorbutton_unlocked, 'toggle_door-' .. uuid)
        local inter2 = Interactable:new(d.x + 54, d.y + 16, assets.images.doorbutton_unlocked, 'toggle_door-' .. uuid)
        World.ecs:addEntity(inter1)
        World.ecs:addEntity(inter2)
    end

    self.drawingsystem = true
end

function TileRendererSystem:update(dt)
    love.graphics.zero()

    World.map:draw()

    if World.debug then
        for _, wall in pairs(World.walls) do
            love.graphics.setColor(0, 255, 0, 200)
            love.graphics.rectangle('line', wall.x, wall.y, wall.width, wall.height)

            love.graphics.setColor(255, 0, 0, 100)
            love.graphics.rectangle('fill', wall.body:getX() - wall.width / 2, wall.body:getY() - wall.height / 2, wall.width, wall.height)
        end
    end
end

return TileRendererSystem
