local SpriteSystem = tiny.processingSystem(class('SpriteSystem'))

SpriteSystem.filter = tiny.requireAll('image', 'position')

SpriteSystem.drawingsystem = true

function SpriteSystem:process(e, dt)
    love.graphics.zero()
    local rotation = e.rotation or 0
    local sx, sy = e.scale and e.scale.x or 1, e.scale and e.scale.y or 1

    love.graphics.draw(e.image, e.position.x, e.position.y, rotation, sx, sy, e.origin.x, e.origin.y)

    if World.debug then
        love.graphics.push()
        love.graphics.translate(e.position.x, e.position.y)
        love.graphics.rotate(e.rotation)
        love.graphics.scale(e.scale.x, e.scale.y)
        love.graphics.setColor(0, 255, 0, 150)
        love.graphics.rectangle('line', -e.origin.x, -e.origin.y, e.width, e.height)
        love.graphics.pop()
        
        if e.hitbox then
            love.graphics.setColor(255, 0, 0, 150)
            e.hitbox:draw('fill')
        end
    end
end

return SpriteSystem
