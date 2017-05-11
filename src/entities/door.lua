local Door = class('Door')

function Door:initialize(x, y, orientation, args) 
    local args = args or {}
    self.orientation = orientation or 'horizontal'
    self.uuid = lume.uuid()
    self.speed = args.speed or 0.5

    self.width  = tools.ternary(self.orientation == 'horizontal', 32, 10)
    self.height = tools.ternary(self.orientation == 'horizontal', 10, 32)
    self.offset = tools.ternary(self.orientation == 'horizontal', { x = 0, y = 3 }, { x = 3, y = 0 })
    self.movementaxis  = tools.ternary(self.orientation == 'horizontal', 'x', 'y')

    self.body    = love.physics.newBody(World.physics, x + self.offset.x + self.width / 2, y + self.offset.y + self.height / 2)
    self.shape   = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData({class = 'barrier', identifier = 'door'})

    self.open = false

    local img = tools.ternary(self.orientation == 'horizontal', 'door_horizontal', 'door_vertical')
    self.image = assets.images[img]

    self.activated = false
    self.open = false
    self.layer = 'fg'

    World.signals.register('toggle_door-' .. self.uuid, function() self:toggle() end)
end

function Door:toggle()
    if self.activated then return false end
    
    local position = { x = self.body:getX(), y = self.body:getY() }
    local movement = tools.ternary(self.open, 32, -32)

    local newposition = { x = position.x, y = position.y }
    newposition[self.movementaxis] = newposition[self.movementaxis] + movement 
    
    flux.to(position, self.speed, { x = newposition.x, y = newposition.y }):onstart(function() 
        self.activated = true
    end):onupdate(function() 
        self.body:setPosition(position.x, position.y)
    end):oncomplete(function()
        self.activated = false
        self.open = not self.open
    end)
end

return Door
