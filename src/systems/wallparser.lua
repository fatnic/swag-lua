local WallParserSystem = tiny.system(class('WallParserSystem'))

function WallParserSystem:initialize()
    World.walls = {}

    local canvas = love.graphics.newCanvas(World.screen.width, World.screen.height)
    love.graphics.setCanvas(canvas)
    World.map:drawTileLayer('walls')
    love.graphics.setCanvas()

    local rects = PixelMerge.parse(canvas:newImageData())

    for _, r in pairs(rects) do
        local wall = Wall.new(r.x, r.y, r.width, r.height)
        wall.body    = love.physics.newBody(World.physics, wall.x + wall.width / 2, wall.y + wall.height / 2)
        wall.shape   = love.physics.newRectangleShape(wall.width, wall.height)
        wall.fixture = love.physics.newFixture(wall.body, wall.shape)
        table.insert(World.walls, wall)
    end

    for _, w in pairs(World.walls) do
        print(w.x ,w.y, w.width, w.height)
    end

    canvas = nil    
end

return WallParserSystem
