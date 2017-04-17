-- external libraries
class    = require 'ext.middleclass'
tiny     = require 'ext.tiny'
sti      = require 'ext.sti'
baton    = require 'ext.baton'
lume     = require 'ext.lume'
flux     = require 'ext.flux'
ParseImg = require 'ext.parseimg'

-- local libraries
Wall   = require 'libs.wall'
PixelMerge = require 'libs.pixelmerge'

-- helpers
tools = require 'tools'

-- parser systems
WallParserSystem   = require 'src.systems.wallparser'
WindowParserSystem = require 'src.systems.windowparser'
DoorParserSystem   = require 'src.systems.doorparser'

-- update systems
ControllableSystem = require 'src.systems.controllable'
LookAtSystem       = require 'src.systems.lookat'
MouseFollowSystem  = require 'src.systems.mousefollow'
InteractableSystem = require 'src.systems.interactable'
UpdatingSystem     = require 'src.systems.updating'
CursorSystem       = require 'src.systems.cursor'
MouseSystem        = require 'src.systems.mouse'

-- drawing systems
TileRendererSystem = require 'src.systems.tilerender'
SpriteSystem       = require 'src.systems.sprite'
VisionSystem       = require 'src.systems.vision'
DebugSystem        = require 'src.systems.debug'

-- system filters
drawingSystems = tiny.requireAll('drawingsystem')
updateSystems  = tiny.rejectAll('drawingsystem')

-- entities
Character             = require 'src.entities.character'
Player                = require 'src.entities.player'
Sprite                = require 'src.entities.sprite'
Door                  = require 'src.entities.door'
Interactable          = require 'src.entities.interactable'
RectangleInteractable = require 'src.entities.rectangleinteractable'
CircleInteractable    = require 'src.entities.circleinteractable'

-- settings
assets = require 'assets'
keys   = require 'keys'

World = {}
World.debug = false

-- TODO: Move this
love.graphics.zero = function()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setStencilTest()
    love.graphics.setBlendMode('alpha')
    love.graphics.setShader()
end

function love.load()
    World.screen     = { width = love.graphics:getWidth(), height = love.graphics:getHeight() }
    World.ecs        = tiny.world()
    World.map        = sti('assets/maps/swag.lua')
    World.input      = baton.new(keys)
    World.signals    = require 'ext.signal'
    World.physics    = love.physics.newWorld(0, 0, true)
    World.characters = {}

    World.ecs:addSystem(WallParserSystem())
    World.ecs:addSystem(WindowParserSystem())
    World.ecs:addSystem(DoorParserSystem())
    -- World.ecs:addSystem(CharacterParserSystem())

    World.ecs:addSystem(MouseSystem())
    World.ecs:addSystem(ControllableSystem())
    World.ecs:addSystem(MouseFollowSystem())
    World.ecs:addSystem(LookAtSystem())
    World.ecs:addSystem(InteractableSystem())
    World.ecs:addSystem(UpdatingSystem())
    World.ecs:addSystem(CursorSystem())

    World.ecs:addSystem(TileRendererSystem('floor'))
    -- World.ecs:addSystem(VisionSystem())
    World.ecs:addSystem(SpriteSystem('characters'))
    World.ecs:addSystem(SpriteSystem('fg'))
    World.ecs:addSystem(TileRendererSystem('windows'))
    World.ecs:addSystem(TileRendererSystem('walls'))
    World.ecs:addSystem(DebugSystem())

    World.characters.player = Player:new(50, 50)
    World.ecs:addEntity(World.characters.player)

    love.mouse.setPosition(World.screen.width / 2, World.screen.height / 2)
end

function love.update(dt)
    love.window.setTitle('swag - ' .. love.timer.getFPS() .. ' fps')

    World.input:update()
    World.physics:update(dt)
    flux.update(dt)

    World.ecs:update(dt, updateSystems)

    if World.input:pressed 'debug' then DebugSystem.active = not DebugSystem.active end
    if World.input:pressed 'doors' then 
        for _, d in pairs(World.doors) do 
            if not d.open then d:toggle() end
        end 
    end
end

function love.draw()
    local dt = love.timer.getDelta()
    World.ecs:update(dt, drawingSystems)
end
