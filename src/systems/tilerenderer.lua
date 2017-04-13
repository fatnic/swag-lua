local TileRendererSystem = tiny.system(class('TileRendererSystem'))

function TileRendererSystem:initialize(args)
    local args = args or {}
    self.drawingsystem = true

    World.walls = {}

    for _, layer in pairs(World.map.layers) do
        if layer.type == 'objectgroup' then layer.visible = false end
    end

    -- World.map.layers['walls'].visible = false

    local collisions = World.map.layers['collisions'].objects
    for _, c in pairs(collisions) do
        -- local wall = Wall.new(c.x, c.y, c.width, c.height)
        local wall = {}
        wall.body    = love.physics.newBody(World.physics, c.x + c.width / 2, c.y + c.height / 2)
        wall.shape   = love.physics.newRectangleShape(c.width, c.height)
        wall.fixture = love.physics.newFixture(wall.body, wall.shape)

        -- table.insert(World.walls, wall)
    end

    World.doors = {}
    local doors = World.map.layers['doors'].objects
    for _, d in pairs(doors) do
        local uuid = math.random(999999)

        local door1 = Door:new(d.x, d.y, uuid, 1)
        local door2 = Door:new(d.x + 24, d.y, uuid, 2)
        World.ecs:addEntity(door1)
        World.ecs:addEntity(door2)

        local b1 = Sprite:new(d.x - 8, d.y - 2,  assets.images.doorbutton_unlocked)
        local b2 = Sprite:new(d.x + 54, d.y + 16, assets.images.doorbutton_unlocked)
        World.ecs:addEntity(b1)
        World.ecs:addEntity(b2)

        local inter1 = CircleInteractable:new(b1.center.x, b1.center.y, 10, 'toggle_door-' .. uuid, { range = 25 })
        local inter2 = CircleInteractable:new(b2.center.x, b2.center.y, 10, 'toggle_door-' .. uuid, { range = 25 })
        World.ecs:addEntity(inter1)
        World.ecs:addEntity(inter2)
    end

end

function TileRendererSystem:update(dt)
    love.graphics.zero()

    World.map:draw()

    if World.debug then
        -- for _, wall in pairs(World.walls) do
        --     love.graphics.setColor(0, 255, 0, 200)
        --     love.graphics.rectangle('line', wall.x, wall.y, wall.width, wall.height)

        --     love.graphics.setColor(255, 0, 0, 100)
        --     love.graphics.rectangle('fill', wall.body:getX() - wall.width / 2, wall.body:getY() - wall.height / 2, wall.width, wall.height)
        -- end
    end
end

return TileRendererSystem
