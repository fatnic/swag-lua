local tools = {}

function tools.ternary(cond, t, f)
    if cond then return t else return f end
end

function tools.distance(v1, v2)
    local dx = v1.x - v2.x
    local dy = v1.y - v2.y
    return math.sqrt(dx * dx + dy * dy)
end

return tools
