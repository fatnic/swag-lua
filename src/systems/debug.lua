local DebugSystem = tiny.system(class('DebugSystem'))

DebugSystem.drawingsystem = true
DebugSystem.active = false

function DebugSystem:update(dt)
    love.graphics.zero()

    local bodies = World.physics:getBodyList()

    love.graphics.setColor(255, 0, 0, 100)
    for _, body in pairs(bodies) do

        local shape = body:getFixtureList()[1]:getShape()

        if shape:getType() == 'polygon' then
            love.graphics.polygon('line', body:getWorldPoints(shape:getPoints()))
        end

        if shape:getType() == 'circle' then
            local x, y = body:getPosition()
            love.graphics.circle('fill', x, y, shape:getRadius())
        end

    end
end

return DebugSystem
