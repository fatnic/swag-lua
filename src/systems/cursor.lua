local CursorSystem = tiny.system(class('CursorSystem'))

function CursorSystem:update(dt)

    if World.mouse.hovering then
        if World.mouse.usable then
            love.mouse.setCursor(assets.cursors.crosshairgreen) 
        else
            love.mouse.setCursor(assets.cursors.crosshairred)
        end
    else
        love.mouse.setCursor(assets.cursors.crosshair) 
    end

end

return CursorSystem
