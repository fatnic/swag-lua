local Door = class('Door')

function Door:initialize(x, y, uuid, direction) 
    self.image = assets.images.door
    self.width = 24
    self.height = 16
    self.uuid = uuid
    self.direction = direction
    self.frame = { x = x, y = y, width = 48, height = 16 }

    self.activated = false
    self.open = false
    self.layer = 'fg'

    self.body    = love.physics.newBody(World.physics, x + self.width / 2, y + self.height / 2)
    self.shape   = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)

    World.signals.register('toggle_door-' .. self.uuid, function() self:toggle() end)
end

function Door:toggle()
    if self.activated then 
        if self:inFrame(World.characters.player) then print('squished') end
        return false
    end

    local x, y = self.body:getX(), self.body:getY()
    local offset = tools.ternary(self.open, self.width, -self.width)
    offset = tools.ternary(self.direction % 2 == 0, -offset, offset)

    local doorpos = { x = x, y = y }
    flux.to(doorpos, 0.3, { x = x + offset }):onstart(function() 
        self.activated = true
    end):onupdate(function() 
        self.body:setPosition(doorpos.x, doorpos.y)
    end):oncomplete(function()
        self.activated = false
        self.open = not self.open
    end)
end

function Door:inFrame(character)
    return      (character.x >= self.frame.x and character.x <= self.frame.x + self.frame.width) 
            and (character.y >= self.frame.y and character.y <= self.frame.y + self.frame.height)
end

return Door
