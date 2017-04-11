local Player = class("Player", Character)

function Player:initialize(x, y, args)
    local args = args or {}
    Character.initialize(self, assets.images.player, x, y, args)

    self.controllable = true
    self.followmouse = true

    self.target = { x = 0, y = 0 }

    self.collidable = true
end

function Player:update(dt)
end

return Player
