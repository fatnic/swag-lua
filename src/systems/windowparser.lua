
local WindowParserSystem = tiny.system(class('WindowParserSystem'))

function WindowParserSystem:initialize()
    World.windows = {}

    local canvas = love.graphics.newCanvas(World.screen.width, World.screen.height)
    love.graphics.setCanvas(canvas)
    World.map:drawTileLayer('windows')
    love.graphics.setCanvas()

    local rects = PixelMerge.parse(canvas:newImageData())

    for _, r in pairs(rects) do
        local window = {}
        window.body    = love.physics.newBody(World.physics, r.x + r.width / 2, r.y + r.height / 2)
        window.shape   = love.physics.newRectangleShape(r.width, r.height)
        window.fixture = love.physics.newFixture(window.body, window.shape)
        table.insert(World.windows, window)
    end

    canvas = nil    
end

return WindowParserSystem
