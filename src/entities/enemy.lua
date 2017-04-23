local Enemy = class("Enemy", Character)

function Enemy:initialize(x, y, args)
    local args = args or {}
    Character.initialize(self, assets.images.enemy, x, y, args)
    self.body:setFixedRotation(true)
    self.speed = 205
    self.hasvision = true
    self.collidable = true
end

function Enemy:update(dt)
    if self.target then self:moveTowards(self.target.x, self.target.y) end
    Character.update(self, dt)
end

return Enemy
