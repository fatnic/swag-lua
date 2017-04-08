-- external libraries
class = require 'ext.middleclass'
tiny  = require 'ext.tiny'
sti   = require 'ext.sti'
baton = require 'ext.baton'

-- local libraries
Wall = require 'libs.wall'

-- update systems
MovementSystem = require 'src.systems.movement'
ControllableSystem = require 'src.systems.controllable'
LookAtSystem = require 'src.systems.lookat'
MouseFollowSystem = require 'src.systems.mousefollow'

-- drawing systems
TileRendererSystem = require 'src.systems.tilerenderer'
SpriteSystem       = require 'src.systems.sprite'

-- system filters
drawingSystems = tiny.requireAll('drawingsystem')
updateSystems = tiny.rejectAll('drawingsystem')

-- entities
Character = require 'src.entities.character'
Player    = require 'src.entities.player'

-- settings
assets = require 'assets'
keys = require 'keys'

World = {}
World.debug = true

love.graphics.reset = function()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setStencilTest()
    love.graphics.setShader()
end

function love.load()
    World.ecs = tiny.world()
    World.map = sti('assets/maps/swag.lua')
    World.input = baton.new(keys)

    World.ecs:addSystem(TileRendererSystem())
    World.ecs:addSystem(SpriteSystem())
    World.ecs:addSystem(MovementSystem())
    World.ecs:addSystem(ControllableSystem())
    World.ecs:addSystem(MouseFollowSystem())
    World.ecs:addSystem(LookAtSystem())

    player = Player:new(50, 50)
    World.ecs:addEntity(player)

    love.mouse.setCursor(assets.cur_crosshair)
end

function love.update(dt)
    love.window.setTitle('swag - ' .. love.timer.getFPS() .. ' fps')
    World.input:update()
    World.ecs:update(dt, updateSystems)
end

function love.draw()
    local dt = love.timer.getDelta()
    World.ecs:update(dt, drawingSystems)
end
