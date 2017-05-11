local Player = class("Player", Character)

function Player:initialize(x, y, args)
    local args = args or {}
    args.identifier = 'player'
    Character.initialize(self, assets.images.player, x, y, args)

    self.target = { x = 0, y = 0 }

    self.hasvision    = nil
    self.controllable = true
    self.followmouse  = true
    self.collidable   = true
    self.canshoot     = true
    self.cooldown     = 0
end

return Player
