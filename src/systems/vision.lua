local VisionSystem = tiny.processingSystem(class('VisionSystem'))

VisionSystem.drawingsystem = true

VisionSystem.filter = tiny.requireAll('hasvision')

function VisionSystem:initialize()
    self.canvas = love.graphics.newCanvas(World.screen.width, World.screen.height)

    self.segments = {}
    self.points = {}

    for _, wall in pairs(World.walls) do
        for _, segment in pairs(wall.segments) do
            table.insert(self.segments, segment)
            -- TODO: check this: maybe remove dupe angles instead???
            local dupe = false
            for _, p in pairs(self.points) do
                if p.x == segment.a.x and p.y == segment.a.y then dupe = true end
            end
            if not dupe then table.insert(self.points, segment.a) end
        end
    end

    -- TODO: Add doors to segments list

    self.raylength = tools.distance({x = 0, y = 0}, {x = World.screen.width, y = World.screen.height})
end

function VisionSystem:onAdd(e)
    e.fov = e.fov or 65
end

function VisionSystem:preWrap(dt)
    -- love.graphics.zero()
    -- love.graphics.setCanvas(self.canvas)
    -- love.graphics.clear()
    -- love.graphics.setColor(255, 255, 255, 50)
end

function VisionSystem:process(e, dt)
    local meshdata = {}
    local origin = { x = e.x, y = e.y }

    e.minFoV = tools.normaliseRadian(e.heading - tools.normaliseRadian(math.rad(e.fov / 2)))
    e.maxFoV = tools.normaliseRadian(e.heading + tools.normaliseRadian(math.rad(e.fov / 2)))

    local angles = self:calcAngles(origin, e.minFoV, e.maxFoV)
    local rays = self:calcRays(origin, angles)
    self:calcIntersects(rays)

    local mindex = tools.getIndexforValue(rays, 'angle', e.minFoV)
    if mindex > 1 then
        rays = tools.rotateTable(rays, mindex)
    end

    table.insert(meshdata, {origin.x, origin.y})
    for _, ray in pairs(rays) do
        if ray.intersect then 
            table.insert(meshdata, {ray.intersect.x, ray.intersect.y})
        end
    end
    table.insert(meshdata, meshdata[1])

    local mesh = love.graphics.newMesh(meshdata, 'fan')
    
    love.graphics.setColor(255, 255,255, 20)
    love.graphics.draw(mesh)
end

function VisionSystem:postWrap(dt)
    -- love.graphics.setCanvas()
    -- love.graphics.setColor(255, 255, 255)
    -- love.graphics.draw(self.canvas)
    -- love.graphics.zero()
end

function VisionSystem:calcAngles(origin, minFoV, maxFoV)
    local angles = {}
    local precision = 0.000001
    table.insert(angles, minFoV)
    table.insert(angles, maxFoV)
    for _, point in pairs(self.points) do
        local angle = math.atan2(point.y - origin.y, point.x - origin.x)
        -- TODO: Check why minFoV disappears when at 0 degrees
        if tools.isAngleBetween(angle, minFoV, maxFoV) then
            table.insert(angles, tools.normaliseRadian(angle) - precision)
            table.insert(angles, tools.normaliseRadian(angle))
            table.insert(angles, tools.normaliseRadian(angle) + precision)
        end
    end
    table.sort(angles, function(a,b) return a < b end)
    return angles    
end

function VisionSystem:calcRays(origin, angles)
    local rays = {}
    for _, angle in pairs(angles) do
        local ray = { a = origin, angle = angle }
        local delta = { x = math.cos(angle), y = math.sin(angle) }
        ray.b = { x = ray.a.x + delta.x * self.raylength, y = ray.a.y + delta.y * self.raylength }
        table.insert(rays, ray)
    end
    return rays
end

function VisionSystem:calcIntersects(rays)
    for _, ray in pairs(rays) do
        local cIntersect = nil
        for _, segment in pairs(self.segments) do
            local intersect = tools.segmentIntersect(ray, segment)
            if intersect then
                intersect.distance = tools.distance(ray.a, intersect)
                if cIntersect then
                    if intersect.distance < cIntersect.distance then cIntersect = intersect end
                else
                    cIntersect = intersect
                end
            end
        end
        if cIntersect then ray.intersect = cIntersect end
    end
end

return VisionSystem
