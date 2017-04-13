local tools = {}

function tools.ternary(cond, t, f)
    if cond then return t else return f end
end

function tools.distance(v1, v2)
    local dx = v1.x - v2.x
    local dy = v1.y - v2.y
    return math.sqrt(dx * dx + dy * dy)
end

function tools.isLineOfSight(p1, p2)
    local ray = { a = { x = p1.x, y = p1.y }, b = { x = p2.x, y = p2.y } }
    for _, wall in pairs(World.walls) do
        for _, segment in pairs(wall.segments) do
            if tools.segmentIntersect(ray, segment) then return false end
        end
    end
    return true
end

function tools.segmentIntersect(ray, segment)
    local a, b = ray.a, ray.b
    local c, d = segment.a, segment.b

    local L1 = {X1=a.x,Y1=a.y,X2=b.x,Y2=b.y}
    local L2 = {X1=c.x,Y1=c.y,X2=d.x,Y2=d.y}

    local d = (L2.Y2 - L2.Y1) * (L1.X2 - L1.X1) - (L2.X2 - L2.X1) * (L1.Y2 - L1.Y1)

    if (d == 0) then return false end

    local n_a = (L2.X2 - L2.X1) * (L1.Y1 - L2.Y1) - (L2.Y2 - L2.Y1) * (L1.X1 - L2.X1)
    local n_b = (L1.X2 - L1.X1) * (L1.Y1 - L2.Y1) - (L1.Y2 - L1.Y1) * (L1.X1 - L2.X1)

    local ua = n_a / d
    local ub = n_b / d

    if (ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1) then
        local x = L1.X1 + (ua * (L1.X2 - L1.X1))
        local y = L1.Y1 + (ua * (L1.Y2 - L1.Y1))
        return true, { x = x, y = y }
    end

    return false
end

return tools
