local Interactable = class('Interactable')

function Interactable:initialize(x, y, image, command)
    self.image = image
    self.position = { x = x, y = y }
    self.rotation = 0
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.command = command
    self.interactive = true
end

function Interactable:activate()
    World.signals.emit(tostring(self.command))
end

return Interactable
