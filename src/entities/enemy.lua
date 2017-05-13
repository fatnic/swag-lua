local Enemy = class("Enemy", Character)

function Enemy:initialize(x, y, args)
    local args = args or {}
    args.identifier = 'enemy'
    Character.initialize(self, assets.images.enemy, x, y, args)
    self.body:setFixedRotation(true)
    self.speed = 250
    self.hasvision = true
    self.collidable = true
    self.stunTimer = 0
end

function Enemy:update(dt)
    local vx, vy = self.body:getLinearVelocity()

    if self.target then 
        local desired = tools.normalise({ x = self.target.x - self.x, y = self.target.y - self.y })
        local dx = desired.x * self.speed
        local dy = desired.y * self.speed
        local steering = { x = dx - vx, y = dy - vy }
        if self.stunTimer == 0 then self.body:applyForce(steering.x, steering.y) end

        if tools.distance({ x = self.x, y = self.y }, self.target) < 1 then self.target = nil end
    end

    Character.update(self, dt)

    self.stunTimer = math.max(0, self.stunTimer - dt)

    print(self.stunTimer)

    if (vx ~= 0 and vy ~= 0) and self.stunTimer == 0 then
        self.heading = math.atan2(vy, vx)
        self.body:setAngle(self.heading)
    end

end

return Enemy
