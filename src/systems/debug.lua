local DebugSystem = tiny.system(class('DebugSystem'))

DebugSystem.drawingsystem = true
DebugSystem.active = false

function DebugSystem:update(dt)
    tools.graphics.clear()

    local bodies = World.physics:getBodyList()

    for _, body in pairs(bodies) do
        love.graphics.setColor(255, 0, 0, 100)

        local shape = body:getFixtureList()[1]:getShape()

        love.graphics.setLineWidth(2)
        if shape:getType() == 'polygon' then
            love.graphics.polygon('line', body:getWorldPoints(shape:getPoints()))
        end

        if shape:getType() == 'circle' then
            local x, y = body:getPosition()
            love.graphics.circle('fill', x, y, shape:getRadius())

            love.graphics.setColor(0, 0, 255)
            local dx = math.cos(body:getAngle())
            local dy = math.sin(body:getAngle())
            local x, y = body:getPosition()
            love.graphics.line(x, y, x + dx * 30, y + dy * 30)
        end
        
        love.graphics.setColor(255, 255, 255)
        local x, y = World.mouse.x, World.mouse.y
        love.graphics.print('[' .. x .. ', ' .. y .. ']', x + 8, y - 26)

    end
end

return DebugSystem
