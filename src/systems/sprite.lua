local SpriteSystem = tiny.processingSystem(class('SpriteSystem'))

SpriteSystem.drawingsystem = true

SpriteSystem.filter = tiny.requireAll('image', tiny.requireAny('x', 'y', 'body'))

function SpriteSystem:initialize(layer)
    self.layer = layer
end

function SpriteSystem:filter(e)
    return e.layer == self.layer
end

function SpriteSystem:process(e, dt)
    tools.graphics.clear()

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

        love.graphics.setColor(0, 0, 255)
        local dx = math.cos(e.heading)
        local dy = math.sin(e.heading)
        love.graphics.line(e.x, e.y, e.x + dx * 100, e.y + dy * 100)

    end

end

return SpriteSystem
