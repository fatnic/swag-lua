
local CircleInteractable = class('CircleInteractable', Interactable)

function CircleInteractable:initialize(x, y, radius, command, args)
    local args = args or {}
    Interactable.initialize(self, x, y, command, args)
    self.width = w
    self.height = h
    self.radius = radius
    self.center = { x = x, y = y }
end

function CircleInteractable:selected()
    local mdist = tools.distance(World.mouse, self.center)
    return mdist < mouse.radius
end

return CircleInteractable
