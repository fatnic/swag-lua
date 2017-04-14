local Character = class("Character")

function Character:initialize(image, x, y, args)
    local args = args or {}

    self.image = image
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.heading = 0
    self.layer = 'characters'

    self.speed = 250

    self.body    = love.physics.newBody(World.physics, x + self.width / 2, y + self.height / 2, 'dynamic')
    -- self.shape   = love.physics.newRectangleShape(self.width, self.height)
    self.shape   = love.physics.newCircleShape(12)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.body:setLinearDamping(6)

    self.updatable = true
end

function Character:moveLeft(dt)
    self.body:applyForce(-self.speed, 0)
end

function Character:moveRight(dt)
    self.body:applyForce(self.speed, 0)
end

function Character:moveDown(dt)
    self.body:applyForce(0, self.speed)
end

function Character:moveUp(dt)
    self.body:applyForce(0, -self.speed)
end

function Character:update(dt)
    self.x, self.y = self.body:getPosition()
    self.heading = self.body:getAngle()
end

return Character
