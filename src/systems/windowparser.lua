
local WindowParserSystem = tiny.system(class('WindowParserSystem'))

function WindowParserSystem:initialize()
    World.windows = {}

    local canvas = love.graphics.newCanvas(World.screen.width, World.screen.height)
    love.graphics.setCanvas(canvas)
    World.map:drawTileLayer('windows')
    love.graphics.setCanvas()

    local rects = ParseImg.rects(canvas:newImageData())

    for _, r in pairs(rects) do
        local window = {}
        window.body    = love.physics.newBody(World.physics, r.x + r.w / 2, r.y + r.h / 2)
        window.shape   = love.physics.newRectangleShape(r.w, r.h)
        window.fixture = love.physics.newFixture(window.body, window.shape)
    end

    canvas = nil    
end

return WindowParserSystem
