local DebugSystem = tiny.system(class('DebugSystem'))

DebugSystem.drawingsystem = true
DebugSystem.active = false

function DebugSystem:update(dt)
    tools.graphics.clear()

    -- draw all physics shapes
    local bodies = World.physics:getBodyList()
    for _, body in pairs(bodies) do
        love.graphics.setColor(255, 0, 0, 100)

        local fixture = body:getFixtureList()[1]
        local shape = fixture:getShape()
        local x, y = body:getPosition()

        love.graphics.setLineWidth(2)
        if shape:getType() == 'polygon' then
            love.graphics.polygon('line', body:getWorldPoints(shape:getPoints()))
        end

        if shape:getType() == 'circle' then
            love.graphics.circle('fill', x, y, shape:getRadius())
            love.graphics.setColor(0, 0, 255, 50)
            local dx = math.cos(body:getAngle())
            local dy = math.sin(body:getAngle())
            local x, y = body:getPosition()
            love.graphics.line(x, y, x + dx * 30, y + dy * 30)
        end

        local udata = fixture:getUserData()
        if udata and udata.identifier then
            love.graphics.setColor(255, 255, 255)
            love.graphics.print(udata.identifier, x, y)
        end

    end

    -- draw player hitpoints
    love.graphics.setColor(255, 255, 0)
    for _, hp in pairs(World.characters.player.hitpoints) do
        love.graphics.points(hp.x, hp.y)
    end

    -- draw enemies
    for _, enemy in pairs(World.characters.enemies) do
        -- fov 
        love.graphics.setColor(0, 255, 0, 50)
        love.graphics.arc('line', enemy.x, enemy.y, enemy.viewdistance, enemy.maxFoV, enemy.minFoV)
    end
        
    -- mouse position
    love.graphics.setColor(255, 255, 255, 150)
    local x, y = World.mouse.x, World.mouse.y
    love.graphics.print('[' .. x .. ', ' .. y .. ']', x + 8, y - 26)

    -- draw gun hits
    love.graphics.setColor(255, 0, 0)
    for _, hit in pairs(World.shots) do
        love.graphics.circle('fill', hit.x, hit.y, 4)
    end
end

return DebugSystem
