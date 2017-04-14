local WallSystem = tiny.system(class('WallSystem'))
WallSystem.drawingsystem = true

function WallSystem:update(dt)
    World.map:drawTileLayer('walls')
end

return WallSystem
