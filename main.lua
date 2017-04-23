-- external libraries
class    = require 'ext.middleclass'
tiny     = require 'ext.tiny'
sti      = require 'ext.sti'
baton    = require 'ext.baton'
lume     = require 'ext.lume'
flux     = require 'ext.flux'
log      = require 'ext.log'
ParseImg = require 'ext.parseimg'
LightWorld = require 'ext.lightworld'

-- local libraries
Wall   = require 'libs.wall'
PixelMerge = require 'libs.pixelmerge'

-- helpers
tools = require 'tools'

-- parser systems
WallParserSystem   = require 'src.systems.wallparser'
WindowParserSystem = require 'src.systems.windowparser'
DoorParserSystem   = require 'src.systems.doorparser'
LightingSystem     = require 'src.systems.lighting'

-- update systems
ControllableSystem = require 'src.systems.controllable'
LookAtSystem       = require 'src.systems.lookat'
MouseFollowSystem  = require 'src.systems.mousefollow'
InteractableSystem = require 'src.systems.interactable'
UpdatingSystem     = require 'src.systems.updating'
CursorSystem       = require 'src.systems.cursor'
MouseSystem        = require 'src.systems.mouse'
VisionSystem       = require 'src.systems.vision'

-- drawing systems
TileRendererSystem = require 'src.systems.tilerender'
SpriteSystem       = require 'src.systems.sprite'
VisionRenderSystem = require 'src.systems.visionrender'
DebugSystem        = require 'src.systems.debug'

-- system filters
drawingSystems = tiny.requireAll('drawingsystem')
updateSystems  = tiny.rejectAll('drawingsystem')

-- entities
Character             = require 'src.entities.character'
Player                = require 'src.entities.player'
Enemy                 = require 'src.entities.enemy'
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

function love.load(arg)
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

    World.ecs:addSystem(MouseSystem())
    World.ecs:addSystem(ControllableSystem())
    World.ecs:addSystem(MouseFollowSystem())
    World.ecs:addSystem(LookAtSystem())
    World.ecs:addSystem(InteractableSystem())
    World.ecs:addSystem(CursorSystem())
    World.ecs:addSystem(LightingSystem())
    World.ecs:addSystem(VisionSystem())
    World.ecs:addSystem(UpdatingSystem())

    World.ecs:addSystem(TileRendererSystem('floor'))
    World.ecs:addSystem(SpriteSystem('characters'))
    World.ecs:addSystem(SpriteSystem('fg'))
    World.ecs:addSystem(VisionRenderSystem())
    World.ecs:addSystem(TileRendererSystem('windows'))
    World.ecs:addSystem(TileRendererSystem('walls'))
    World.ecs:addSystem(DebugSystem())

    World.characters.player = Player:new(64, 64)
    World.ecs:addEntity(World.characters.player)

    for _, enemy in pairs(require 'enemies') do
        local e = Enemy:new(enemy.x, enemy.y)
        World.ecs:addEntity(e)
    end

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
        for _, d in pairs(World.doors) do d:toggle() end
    end
end

function love.draw()
    local dt = love.timer.getDelta()
    World.lights:draw(function()
        World.ecs:update(dt, drawingSystems)
    end)
end
