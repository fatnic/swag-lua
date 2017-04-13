local SpriteSystem = tiny.processingSystem(class('SpriteSystem'))

SpriteSystem.drawingsystem = true

SpriteSystem.filter = tiny.requireAll('image', tiny.requireAny('x', 'y', 'body'))

function SpriteSystem:process(e, dt)
    love.graphics.zero()

    if e.body then
        love.graphics.draw(e.image, e.body:getX(), e.body:getY(), e.body:getAngle(), 1, 1, e.width / 2, e.height / 2)
    else
        local rotation = e.rotation or 0
        love.graphics.draw(e.image, e.x, e.y, rotation)
    end

    if World.debug then
        love.graphics.setColor(255, 0, 0, 100)
        if e.body then
            love.graphics.polygon('fill', e.body:getWorldPoints(e.shape:getPoints()))
        else
            love.graphics.rectangle('fill', e.x, e.y, e.width, e.height)
        end
    end
end

return SpriteSystem
