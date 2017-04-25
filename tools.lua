local tools = {}
tools.graphics = {}

tools.graphics.clear = function()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setStencilTest()
    love.graphics.setBlendMode('alpha')
    love.graphics.setShader()
end

function tools.ternary(cond, t, f)
    if cond then return t else return f end
end

function tools.normaliseRadian(rad)
    local result = rad % (2 * math.pi)
    if result < 0 then result = result + (2 * math.pi) end
    return result
end

function tools.isAngleBetween(angle, min, max)
    local rad = math.pi * 2
    local angle = (rad + (angle % rad)) % rad
    local min = (rad + min) % rad
    local max = (rad + max) % rad
    if (min < max) then return min <= angle and angle <= max end
    return min <= angle or angle <= max
end

function tools.distance(v1, v2)
    local dx = v1.x - v2.x
    local dy = v1.y - v2.y
    return math.sqrt(dx * dx + dy * dy)
end

function tools.isLineOfSight(p1, p2)
    local hit = false
    World.physics:rayCast(p1.x, p1.y, p2.x, p2.y, function(fixture, x, y, xn, yn, fraction) 
        local shape = fixture:getShape()
        if shape:getType() == 'circle' then return 1 end
        hit = true
        return 1
    end)
    return not hit
end

return tools
