local DebugSystem = tiny.system(class('DebugSystem'))

DebugSystem.drawingsystem = true
DebugSystem.active = false

function DebugSystem:initialize()
    -- self.canvas = love.graphics.newCanvas(World.screen.width, World.width.height)
end

function DebugSystem:preWrap(dt)

end

function DebugSystem:update(dt)
    love.graphics.zero()
    
    local bodies = World.physics:getBodyList()

    love.graphics.setColor(255, 0, 0, 100)
    for _, body in pairs(bodies) do

        local shape = body:getFixtureList()[1]:getShape()

        if shape:getType() == 'polygon' then
            love.graphics.polygon('fill', body:getWorldPoints(shape:getPoints()))
        end

        if shape:getType() == 'circle' then
            local x, y = body:getPosition()
            love.graphics.circle('fill', x, y, shape:getRadius())
        end

    end
end

function DebugSystem:postWrap(dt)

end

return DebugSystem
