local Player = class("Player", Character)

function Player:initialize(x, y, args)
    local args = args or {}
    Character.initialize(self, assets.images.player, x, y, args)

    self.target = { x = 0, y = 0 }
    self.hasvision = true

    self.controllable = true
    self.followmouse = true
    self.collidable = true
end

return Player
