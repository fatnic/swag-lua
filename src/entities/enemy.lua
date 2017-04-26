local Enemy = class("Enemy", Character)

function Enemy:initialize(x, y, args)
    local args = args or {}
    Character.initialize(self, assets.images.enemy, x, y, args)
    self.body:setFixedRotation(true)
    self.speed = 350
    self.hasvision = true
    self.collidable = true
end

function Enemy:update(dt)
    if self.target then 
        local desired = tools.normalise({ x = self.target.x - self.x, y = self.target.y - self.y })
        local dx = desired.x * self.speed
        local dy = desired.y * self.speed

        local vx, vy = self.body:getLinearVelocity()

        local steering = { x = dx - vx, y = dy - vy }
        self.body:applyForce(steering.x, steering.y)

        if tools.distance({ x = self.x, y = self.y }, self.target) < 1 then self.target = nil end
    end

    Character.update(self, dt)

    local dx, dy = self.body:getLinearVelocity()
    self.heading = math.atan2(dy, dx)
    self.body:setAngle(self.heading)
end

return Enemy
