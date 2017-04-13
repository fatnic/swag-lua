-- external libraries
class = require 'ext.middleclass'
tiny  = require 'ext.tiny'
sti   = require 'ext.sti'
baton = require 'ext.baton'
lume  = require 'ext.lume'
flux  = require 'ext.flux'

-- local libraries
Wall = require 'libs.wall'

-- helpers
tools = require 'tools'

-- update systems
ControllableSystem = require 'src.systems.controllable'
LookAtSystem       = require 'src.systems.lookat'
MouseFollowSystem  = require 'src.systems.mousefollow'
InteractableSystem = require 'src.systems.interactable'
UpdatingSystem     = require 'src.systems.updating'
CursorSystem       = require 'src.systems.cursor'

-- drawing systems
TileRendererSystem = require 'src.systems.tilerenderer'
SpriteSystem       = require 'src.systems.sprite'

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

love.graphics.zero = function()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setStencilTest()
    love.graphics.setShader()
end

function love.load()
    World.ecs        = tiny.world()
    World.map        = sti('assets/maps/swag.lua')
    World.input      = baton.new(keys)
    World.signals    = require 'ext.signal'
    World.physics    = love.physics.newWorld(0, 0, true)
    World.characters = {}

    World.ecs:addSystem(TileRendererSystem())
    World.ecs:addSystem(SpriteSystem('fg'))

    World.ecs:addSystem(ControllableSystem())
    World.ecs:addSystem(MouseFollowSystem())
    World.ecs:addSystem(LookAtSystem())
    World.ecs:addSystem(InteractableSystem())
    World.ecs:addSystem(UpdatingSystem())
    World.ecs:addSystem(CursorSystem())

    World.characters.player = Player:new(50, 50)
    World.ecs:addEntity(World.characters.player)
end

function love.update(dt)
    love.window.setTitle('swag - ' .. love.timer.getFPS() .. ' fps')
    World.mouse = { x = love.mouse.getX() + 8, y = love.mouse.getY() + 8, hovering = false, usable = false }

    World.input:update()
    World.physics:update(dt)
    flux.update(dt)
    World.ecs:update(dt, updateSystems)

    if World.input:pressed 'debug' then World.debug = not World.debug end
end

function love.draw()
    local dt = love.timer.getDelta()
    World.ecs:update(dt, drawingSystems)
    World.map:drawTileLayer('walls')
end
