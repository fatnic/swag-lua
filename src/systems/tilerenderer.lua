local TileRendererSystem = tiny.system(class('TileRendererSystem'))

function TileRendererSystem:initialize(args)
    local args = args or {}
    World.walls = {}

    for _, layer in pairs(World.map.layers) do
        if layer.type == 'objectgroup' then layer.visible = false end
    end

    local collisions = World.map.layers['collisions'].objects
    for _, c in pairs(collisions) do
        local wall = Wall.new(c.x, c.y, c.width, c.height)

        wall.body    = love.physics.newBody(World.physics, c.x + c.width / 2, c.y + c.height / 2)
        wall.shape   = love.physics.newRectangleShape(c.width, c.height)
        wall.fixture = love.physics.newFixture(wall.body, wall.shape)

        table.insert(World.walls, wall)
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
