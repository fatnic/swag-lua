local TileRendererSystem = tiny.system(class('TileRendererSystem'))

function TileRendererSystem:initialize(args)
    local args = args or {}

    for _, layer in pairs(World.map.layers) do
        if layer.type == 'objectgroup' then layer.visible = false end
    end

    self.drawingsystem = true
end

function TileRendererSystem:update(dt)
    love.graphics.reset()

    World.map:draw()
end

return TileRendererSystem
