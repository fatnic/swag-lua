local Character = class("Character")

function Character:initialize(image, x, y, args)
    local args = args or {}

    self.image   = image
    self.uuid    = lume.uuid()
    self.width   = self.image:getWidth()
    self.height  = self.image:getHeight()
    self.heading = 0
    self.radius  = 12
    self.layer   = 'characters'

    self.speed = 275
    
    self.body    = love.physics.newBody(World.physics, x + self.width / 2, y + self.height / 2, 'dynamic')
    self.shape   = love.physics.newCircleShape(self.radius)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.body:setLinearDamping(6)

    self.x, self.y = self.body:getPosition()

    self.updatable = true

    self.hitpoints = {}
    self.hitpoints[1] = { x = self.x, y = self.y + self.radius }
    self.hitpoints[2] = { x = self.x, y = self.y - self.radius }
    self.hitpoints[3] = { x = self.x + self.radius, y = self.y }
    self.hitpoints[4] = { x = self.x - self.radius, y = self.y }
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

    self.hitpoints[1] = { x = self.x, y = self.y + self.radius }
    self.hitpoints[2] = { x = self.x, y = self.y - self.radius }
    self.hitpoints[3] = { x = self.x + self.radius, y = self.y }
    self.hitpoints[4] = { x = self.x - self.radius, y = self.y }
end

function Character:moveTowards(x, y, dt)
    local angle = math.atan2(y - self.y, x - self.x)
    local dx, dy = math.cos(angle), math.sin(angle)
    self.body:setAngle(angle)
    self.body:applyForce(dx * self.speed, dy * self.speed)
end

function Character:debug()
    love.graphics.setColor(0, 255, 0)
    local delta = { x = math.cos(self.heading), y = math.sin(self.heading) }
    love.graphics.line(self.x, self.y, self.x + delta.x * 30, self.y + delta.y * 30) 
end

return Character
