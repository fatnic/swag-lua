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
LookAtSystem = require 'src.systems.lookat'
MouseFollowSystem = require 'src.systems.mousefollow'
InteractableSystem = require 'src.systems.interactable'

-- drawing systems
TileRendererSystem = require 'src.systems.tilerenderer'
SpriteSystem       = require 'src.systems.sprite'

-- system filters
drawingSystems = tiny.requireAll('drawingsystem')
updateSystems  = tiny.rejectAll('drawingsystem')

-- entities
Character = require 'src.entities.character'
Player    = require 'src.entities.player'
Door      = require 'src.entities.door'
Interactable = require 'src.entities.interactable'

-- settings
assets = require 'assets'
keys = require 'keys'

World = {}
World.debug = false

love.graphics.zero = function()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setStencilTest()
    love.graphics.setShader()
end

function love.load()
    World.ecs = tiny.world()
    World.map = sti('assets/maps/swag.lua')
    World.input = baton.new(keys)
    World.signals = require 'ext.signal'
    World.physics = love.physics.newWorld(0, 0, true)

    World.ecs:addSystem(TileRendererSystem())
    World.ecs:addSystem(SpriteSystem())

    World.ecs:addSystem(ControllableSystem())
    World.ecs:addSystem(MouseFollowSystem())
    World.ecs:addSystem(LookAtSystem())
    World.ecs:addSystem(InteractableSystem())

    player = Player:new(50, 50)
    World.ecs:addEntity(player)

    love.mouse.setCursor(assets.cursors.crosshair)
end

function love.update(dt)
    love.window.setTitle('swag - ' .. love.timer.getFPS() .. ' fps')
    World.mouse = { x = love.mouse.getX() + 8, y = love.mouse.getY() + 8 }
    World.input:update()
    World.physics:update(dt)
    flux.update(dt)

    if World.input:pressed 'debug' then World.debug = not World.debug end

    World.ecs:update(dt, updateSystems)
end

function love.draw()
    local dt = love.timer.getDelta()
    World.ecs:update(dt, drawingSystems)
    World.map:drawTileLayer('walls')
end
