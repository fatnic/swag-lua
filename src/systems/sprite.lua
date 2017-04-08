local SpriteSystem = tiny.processingSystem(class('SpriteSystem'))

SpriteSystem.filter = tiny.requireAll('image')

SpriteSystem.drawingsystem = true

function SpriteSystem:process(e, dt)
    love.graphics.zero()

    love.graphics.draw(e.image, e.body:getX(), e.body:getY(), e.body:getAngle(), 1, 1, e.width / 2, e.height / 2)

    if World.debug then
        love.graphics.setColor(255, 0, 0, 100)
        love.graphics.polygon('fill', e.body:getWorldPoints(e.shape:getPoints()))
    end
end

return SpriteSystem
