local WallParserSystem = tiny.system(class('WallParserSystem'))

function WallParserSystem:initialize()
    World.walls = {}

    local canvas = love.graphics.newCanvas(World.screen.width, World.screen.height)
    love.graphics.setCanvas(canvas)
    World.map:drawTileLayer('walls')
    love.graphics.setCanvas()

    local rects = ParseImg.rects(canvas:newImageData())

    for _, r in pairs(rects) do
        local wall = Wall.new(r.x, r.y, r.w, r.h)
        wall.body    = love.physics.newBody(World.physics, r.x + r.w / 2, r.y + r.h / 2)
        wall.shape   = love.physics.newRectangleShape(r.w, r.h)
        wall.fixture = love.physics.newFixture(wall.body, wall.shape)
        table.insert(World.walls, wall)
    end

    canvas = nil    
end

return WallParserSystem
