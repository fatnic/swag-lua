local TileRenderSystem = tiny.system(class('TileRenderSystem'))

function TileRenderSystem:initialize(layer)
    self.drawingsystem = true
    self.layer = layer
end

function TileRenderSystem:update(dt)
    love.graphics.zero()
    World.map:drawTileLayer(self.layer)
end

return TileRenderSystem
