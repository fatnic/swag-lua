local Character = class("Character")

function Character:initialize(image, x, y, args)
    local args = args or {}
    self.image = image
    self.position = { x = x or 0, y = y or 0 }
    self.rotation = args.rotation or 0
    self.scale = args.scale or { x = 1, y = 1 }
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.origin = { x = self.width / 2, y = self.height / 2 }

    self.velocity = { x = 0, y = 0 }
    self.acceleration = { x = 0, y = 0 }
    self.speed = 20
end

function Character:moveLeft(dt)
    self.acceleration.x = -1 * self.speed * dt
end

function Character:moveRight(dt)
    self.acceleration.x = 1 * self.speed * dt
end

function Character:moveDown(dt)
    self.acceleration.y = 1 * self.speed * dt
end

function Character:moveUp(dt)
    self.acceleration.y = -1 * self.speed * dt
end

return Character
