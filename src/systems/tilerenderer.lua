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
        wall.hitbox = HC.rectangle(c.x, c.y, c.width, c.height)
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
            if wall.hitbox then 
                love.graphics.setColor(255, 0, 0, 150)
                wall.hitbox:draw('fill') 
            end
        end
    end
end

return TileRendererSystem
