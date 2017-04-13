local Player = class("Player", Character)

function Player:initialize(x, y, args)
    local args = args or {}
    Character.initialize(self, assets.images.player, x, y, args)

    self.controllable = true

    self.target = { x = 0, y = 0 }
    self.followmouse = true

    self.collidable = true
end

return Player
