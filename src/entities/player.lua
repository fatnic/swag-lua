local Player = class("Player", Character)

function Player:initialize(x, y, args)
    local args = args or {}
    Character.initialize(self, assets.img_player, x, y, args)

    self.velocity = { x = 0, y = 0 }
    self.target = { x = 0, y = 0 }
    self.speed = 30
    
    self.controllable = true
    self.followmouse = true
end

function Player:update(dt)
end

return Player
