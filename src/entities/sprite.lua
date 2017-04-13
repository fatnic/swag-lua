local Sprite = class('Sprite')

function Sprite:initialize(x, y, image, layer)
    self.image = image
    self.x = x
    self.y = y
    self.width = image:getWidth()
    self.height = image:getHeight()
    self.center = { x = x + self.width / 2, y = y + self.height / 2 }
    self.layer = layer or 'fg'
end

return Sprite
