local MouseSystem = tiny.system(class('MouseSystem'))

function MouseSystem:update(dt)
    World.mouse = { x = love.mouse.getX() + 8, y = love.mouse.getY() + 8, hovering = false, usable = false }
end

return MouseSystem
