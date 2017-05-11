local WallParserSystem = tiny.system(class('WallParserSystem'))

function WallParserSystem:initialize()
    World.walls = {}

    local canvas = love.graphics.newCanvas(World.screen.width, World.screen.height)
    local small_canvas = love.graphics.newCanvas(World.screen.width / 16, World.screen.height / 16)
    love.graphics.setCanvas(canvas)
    World.map:drawTileLayer('walls')
    love.graphics.setCanvas(small_canvas)
    love.graphics.draw(canvas, 0, 0, 0, 1/16, 1/16)
    love.graphics.setCanvas()

    local rects = ParseImg.rects(small_canvas:newImageData())

    for _, r in pairs(rects) do
        local wall = Wall.new(r.x * 16, r.y * 16, r.w * 16, r.h * 16)
        wall.body    = love.physics.newBody(World.physics, wall.x + wall.width / 2, wall.y + wall.height / 2)
        wall.shape   = love.physics.newRectangleShape(wall.width, wall.height)
        wall.fixture = love.physics.newFixture(wall.body, wall.shape)
        wall.fixture:setUserData({class = 'barrier', identifier = 'wall'})
        table.insert(World.walls, wall)
    end

    canvas = nil    
end

return WallParserSystem
